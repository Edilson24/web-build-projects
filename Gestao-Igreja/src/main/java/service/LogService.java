package service;

import dao.LogDAO;
import model.Log;

public class LogService {
    private static final LogDAO logDAO = new LogDAO();

    /**
     * Registra centralizadamente uma ação no banco de dados.
     * @param idusuario ID do usuário logado que executou a ação
     * @param departamento 'SECRETARIA', 'TESOURARIA', 'PASTORAL' ou 'SISTEMA'[cite: 8]
     * @param acao Descrição detalhada da operação realizada[cite: 5, 8]
     */
    public static void registrar(Integer idusuario, String departamento, String acao) {
        if (idusuario != null && departamento != null && acao != null) {
            Log log = new Log(idusuario, departamento, acao);
            logDAO.salvar(log);
        }
    }
}