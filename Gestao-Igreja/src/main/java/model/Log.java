package model;

import java.sql.Timestamp;

public class Log {
    private Integer idlog;
    private Integer idusuario;
    private String departamento; // ENUM: 'SECRETARIA', 'TESOURARIA', 'PASTORAL', 'SISTEMA'
    private String acao;
    private Timestamp dataHora;
    private String nomeUsuario; // Campo auxiliar para exibição de joins

    public Log() {}

    public Log(Integer idusuario, String departamento, String acao) {
        this.idusuario = idusuario;
        this.departamento = departamento;
        this.acao = acao;
    }

    public Integer getIdlog() { return idlog; }
    public void setIdlog(Integer idlog) { this.idlog = idlog; }

    public Integer getIdusuario() { return idusuario; }
    public void setIdusuario(Integer idusuario) { this.idusuario = idusuario; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    public String getAcao() { return acao; }
    public void setAcao(String acao) { this.acao = acao; }

    public Timestamp getDataHora() { return dataHora; }
    public void setDataHora(Timestamp dataHora) { this.dataHora = dataHora; }

    public String getNomeUsuario() { return nomeUsuario; }
    public void setNomeUsuario(String nomeUsuario) { this.nomeUsuario = nomeUsuario; }
}