package service;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailRecuperacaoService {

    public void enviarPin(String destinatario, String nome, String pin) throws MessagingException {
        String host = configuracaoObrigatoria("SMTP_HOST");
        String usuario = configuracaoObrigatoria("SMTP_USER");
        String senha = configuracaoObrigatoria("SMTP_PASSWORD");
        String remetente = System.getenv("SMTP_FROM");
        String porta = System.getenv("SMTP_PORT");
        String startTls = System.getenv("SMTP_STARTTLS");

        Properties propriedades = new Properties();
        propriedades.put("mail.smtp.host", host);
        propriedades.put("mail.smtp.port", porta == null || porta.trim().isEmpty() ? "587" : porta.trim());
        propriedades.put("mail.smtp.auth", "true");
        propriedades.put("mail.smtp.starttls.enable", startTls == null ? "true" : startTls);
        propriedades.put("mail.smtp.starttls.required", startTls == null || Boolean.parseBoolean(startTls) ? "true" : "false");
        propriedades.put("mail.smtp.connectiontimeout", "10000");
        propriedades.put("mail.smtp.timeout", "10000");
        propriedades.put("mail.smtp.writetimeout", "10000");

        Session sessao = Session.getInstance(propriedades, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuario, senha);
            }
        });

        MimeMessage mensagem = new MimeMessage(sessao);
        mensagem.setFrom(new InternetAddress(remetente == null || remetente.trim().isEmpty() ? usuario : remetente.trim()));
        mensagem.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario, false));
        mensagem.setSubject("PIN para recuperação de senha - SIGEIGREJA", "UTF-8");
        mensagem.setText("Olá, " + nome + ".\n\nSeu PIN para redefinir a senha é: " + pin
                + "\n\nO código expira em 10 minutos. Se você não solicitou esta alteração, ignore este e-mail.",
                "UTF-8");
        Transport.send(mensagem);
    }

    private String configuracaoObrigatoria(String nome) {
        String valor = System.getenv(nome);
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalStateException("Configure a variável de ambiente " + nome + " para habilitar o envio de e-mail.");
        }
        return valor.trim();
    }
}
