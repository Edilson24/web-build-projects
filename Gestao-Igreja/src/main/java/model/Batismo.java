package model;

import java.sql.Date;
import java.util.List;

public class Batismo {
    private int idbatismo;
    private Date data;
    private String local;
    private int idpastor;
    private String nomePastor; // Campo auxiliar para exibição nas tabelas
    private int totalCandidatos; // Contador de inscritos (Máx 10)
    private List<DetalheBatismo> candidatos;

    public Batismo() {}

    public int getIdbatismo() { return idbatismo; }
    public void setIdbatismo(int idbatismo) { this.idbatismo = idbatismo; }

    public Date getData() { return data; }
    public void setData(Date data) { this.data = data; }

    public String getLocal() { return local; }
    public void setLocal(String local) { this.local = local; }

    public int getIdpastor() { return idpastor; }
    public void setIdpastor(int idpastor) { this.idpastor = idpastor; }

    public String getNomePastor() { return nomePastor; }
    public void setNomePastor(String nomePastor) { this.nomePastor = nomePastor; }

    public int getTotalCandidatos() { return totalCandidatos; }
    public void setTotalCandidatos(int totalCandidatos) { this.totalCandidatos = totalCandidatos; }

    public List<DetalheBatismo> getCandidatos() { return candidatos; }
    public void setCandidatos(List<DetalheBatismo> candidatos) { this.candidatos = candidatos; }
}