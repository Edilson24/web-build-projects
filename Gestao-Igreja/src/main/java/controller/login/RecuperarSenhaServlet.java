package controller.login;

import dao.UsuarioDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.EmailRecuperacaoService;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.Locale;

@WebServlet("/recuperar-senha")
public class RecuperarSenhaServlet extends HttpServlet {

    private static final String SESSION_EMAIL = "recuperacaoEmail";
    private static final String SESSION_PIN_HASH = "recuperacaoPinHash";
    private static final String SESSION_EXPIRACAO = "recuperacaoExpiracao";
    private static final String SESSION_TENTATIVAS = "recuperacaoTentativas";
    private static final String SESSION_VERIFICADO = "recuperacaoVerificado";
    private static final long VALIDADE_PIN_MS = 10 * 60 * 1000L;
    private static final int MAX_TENTATIVAS = 5;
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final EmailRecuperacaoService emailService = new EmailRecuperacaoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && sessaoExpirada(session)) {
            limparRecuperacao(session);
        }

        String etapa = "email";
        if (session != null && Boolean.TRUE.equals(session.getAttribute(SESSION_VERIFICADO))) {
            etapa = "senha";
        } else if (session != null && session.getAttribute(SESSION_PIN_HASH) != null) {
            etapa = "pin";
        }
        mostrarEtapa(req, resp, etapa);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");
        if ("solicitar".equals(acao)) {
            solicitarPin(req, resp);
        } else if ("verificar".equals(acao)) {
            verificarPin(req, resp);
        } else if ("alterar".equals(acao)) {
            alterarSenha(req, resp);
        } else {
            req.setAttribute("erro", "Solicitação inválida. Inicie novamente a recuperação.");
            mostrarEtapa(req, resp, "email");
        }
    }

    private void solicitarPin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("erro", "Informe o e-mail da sua conta.");
            mostrarEtapa(req, resp, "email");
            return;
        }

        email = email.trim();
        HttpSession session = req.getSession();
        limparRecuperacao(session);

        try {
            String nome = usuarioDAO.buscarNomePorEmail(email);
            if (nome != null) {
                String pin = String.format(Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
                session.setAttribute(SESSION_EMAIL, email);
                session.setAttribute(SESSION_PIN_HASH, hashPin(pin));
                session.setAttribute(SESSION_EXPIRACAO, System.currentTimeMillis() + VALIDADE_PIN_MS);
                session.setAttribute(SESSION_TENTATIVAS, 0);

                try {
                    emailService.enviarPin(email, nome, pin);
                } catch (MessagingException | IllegalStateException e) {
                    limparRecuperacao(session);
                    System.err.println("Falha ao enviar PIN de recuperação: " + e.getMessage());
                    req.setAttribute("erro", "Não foi possível enviar o código agora. Verifique a configuração de e-mail e tente novamente.");
                    mostrarEtapa(req, resp, "email");
                    return;
                }
                req.setAttribute("mensagem", "Se o e-mail estiver cadastrado, você receberá um PIN válido por 10 minutos.");
                mostrarEtapa(req, resp, "pin");
            } else {
                String pinInvalido = String.format(Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
                session.setAttribute(SESSION_EMAIL, email);
                session.setAttribute(SESSION_PIN_HASH, hashPin(pinInvalido));
                session.setAttribute(SESSION_EXPIRACAO, System.currentTimeMillis() + VALIDADE_PIN_MS);
                session.setAttribute(SESSION_TENTATIVAS, 0);
                req.setAttribute("mensagem", "Se o e-mail estiver cadastrado, você receberá um PIN válido por 10 minutos.");
                mostrarEtapa(req, resp, "pin");
            }
        } catch (SQLException e) {
            throw new ServletException("Não foi possível consultar a conta para recuperação de senha.", e);
        }
    }

    private void verificarPin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(SESSION_PIN_HASH) == null || sessaoExpirada(session)) {
            if (session != null) {
                limparRecuperacao(session);
            }
            req.setAttribute("erro", "O código expirou ou não existe. Solicite um novo PIN.");
            mostrarEtapa(req, resp, "email");
            return;
        }

        String pin = req.getParameter("pin");
        if (pin == null || !pin.matches("\\d{6}")) {
            req.setAttribute("erro", "Informe o PIN de 6 dígitos recebido por e-mail.");
            mostrarEtapa(req, resp, "pin");
            return;
        }

        int tentativas = (Integer) session.getAttribute(SESSION_TENTATIVAS) + 1;
        session.setAttribute(SESSION_TENTATIVAS, tentativas);
        byte[] hashArmazenado = (byte[]) session.getAttribute(SESSION_PIN_HASH);
        if (MessageDigest.isEqual(hashArmazenado, hashPin(pin))) {
            session.removeAttribute(SESSION_PIN_HASH);
            session.removeAttribute(SESSION_TENTATIVAS);
            session.setAttribute(SESSION_VERIFICADO, true);
            mostrarEtapa(req, resp, "senha");
            return;
        }

        if (tentativas >= MAX_TENTATIVAS) {
            limparRecuperacao(session);
            req.setAttribute("erro", "Limite de tentativas excedido. Solicite um novo PIN.");
            mostrarEtapa(req, resp, "email");
            return;
        }

        req.setAttribute("erro", "PIN incorreto. Verifique o código e tente novamente.");
        mostrarEtapa(req, resp, "pin");
    }

    private void alterarSenha(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute(SESSION_VERIFICADO)) || sessaoExpirada(session)) {
            if (session != null) {
                limparRecuperacao(session);
            }
            req.setAttribute("erro", "A autorização expirou. Solicite um novo PIN.");
            mostrarEtapa(req, resp, "email");
            return;
        }

        String senha = req.getParameter("senha");
        String confirmarSenha = req.getParameter("confirmarSenha");
        if (senha == null || senha.length() < 8) {
            req.setAttribute("erro", "A nova senha deve ter pelo menos 8 caracteres.");
            mostrarEtapa(req, resp, "senha");
            return;
        }
        if (senha.length() > 255) {
            req.setAttribute("erro", "A nova senha não pode ultrapassar 255 caracteres.");
            mostrarEtapa(req, resp, "senha");
            return;
        }
        if (!senha.equals(confirmarSenha)) {
            req.setAttribute("erro", "As senhas informadas não coincidem.");
            mostrarEtapa(req, resp, "senha");
            return;
        }

        String email = (String) session.getAttribute(SESSION_EMAIL);
        try {
            if (!usuarioDAO.atualizarSenha(email, senha)) {
                limparRecuperacao(session);
                req.setAttribute("erro", "Não foi possível atualizar a senha. Solicite um novo PIN.");
                mostrarEtapa(req, resp, "email");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Não foi possível atualizar a senha.", e);
        }

        limparRecuperacao(session);
        req.setAttribute("mensagem", "Sua senha foi alterada. Você já pode entrar com a nova senha.");
        mostrarEtapa(req, resp, "concluido");
    }

    private boolean sessaoExpirada(HttpSession session) {
        Long expiracao = (Long) session.getAttribute(SESSION_EXPIRACAO);
        return expiracao == null || System.currentTimeMillis() > expiracao;
    }

    private byte[] hashPin(String pin) {
        try {
            return MessageDigest.getInstance("SHA-256").digest(pin.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 não está disponível.", e);
        }
    }

    private void limparRecuperacao(HttpSession session) {
        session.removeAttribute(SESSION_EMAIL);
        session.removeAttribute(SESSION_PIN_HASH);
        session.removeAttribute(SESSION_EXPIRACAO);
        session.removeAttribute(SESSION_TENTATIVAS);
        session.removeAttribute(SESSION_VERIFICADO);
    }

    private void mostrarEtapa(HttpServletRequest req, HttpServletResponse resp, String etapa)
            throws ServletException, IOException {
        req.setAttribute("etapa", etapa);
        req.getRequestDispatcher("/views/login/recuperar_senha.jsp").forward(req, resp);
    }
}
