package model;

import java.sql.Date;

public class Crente {
    private Integer idcrente;
    private String nome;
    private Date dataNascimento;
    private String telefone;
    private String endereco;
    private String estadoCivil; // ENUM: 'Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)'
    private String statusBatismo; // ENUM: 'NÃO_BATIZADO', 'AGUARDANDO_BATISMO', 'BATIZADO'
    private Date dataEntrada;
    private Integer idgrupo;
    private String fotoUrl;

    public Crente() {}

    public Integer getIdcrente() { return idcrente; }
    public void setIdcrente(Integer idcrente) { this.idcrente = idcrente; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public Date getDataNascimento() { return dataNascimento; }
    public void setDataNascimento(Date dataNascimento) { this.dataNascimento = dataNascimento; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getEstadoCivil() { return estadoCivil; }
    public void setEstadoCivil(String estadoCivil) { this.estadoCivil = estadoCivil; }

    public String getStatusBatismo() { return statusBatismo; }
    public void setStatusBatismo(String statusBatismo) { this.statusBatismo = statusBatismo; }

    public Date getDataEntrada() { return dataEntrada; }
    public void setDataEntrada(Date dataEntrada) { this.dataEntrada = dataEntrada; }

    public Integer getIdgrupo() { return idgrupo; }
    public void setIdgrupo(Integer idgrupo) { this.idgrupo = idgrupo; }

    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }
}