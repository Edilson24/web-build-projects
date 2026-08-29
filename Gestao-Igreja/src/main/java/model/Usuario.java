package model;

public class Usuario {
    private Integer idusuario;
    private Integer idcrente;
    private String nome;
    private String email;
    private String senha;
    private String funcao; // ENUM: 'ADMINISTRADOR', 'SECRETARIO', 'TESOUREIRO', 'PASTOR'
    private String fotoUrl;

    public Usuario() {}

    public Usuario(Integer idusuario, Integer idcrente, String nome, String email, String senha, String funcao, String fotoUrl) {
        this.idusuario = idusuario;
        this.idcrente = idcrente;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.funcao = funcao;
        this.fotoUrl = fotoUrl;
    }

    public Integer getIdusuario() { return idusuario; }
    public void setIdusuario(Integer idusuario) { this.idusuario = idusuario; }

    public Integer getIdcrente() { return idcrente; }
    public void setIdcrente(Integer idcrente) { this.idcrente = idcrente; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public String getFuncao() { return funcao; }
    public void setFuncao(String funcao) { this.funcao = funcao; }

    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }
}