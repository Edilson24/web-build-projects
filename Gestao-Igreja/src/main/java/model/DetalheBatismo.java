package model;

public class DetalheBatismo {
    private int iddetalhe;
    private int idbatismo;
    private int idcrente;
    private String nomeCrente; // Auxiliar para listagem
    private String padrinho;
    private String madrinha;
    private boolean confirmado;

    public DetalheBatismo() {}

    public int getIddetalhe() { return iddetalhe; }
    public void setIddetalhe(int iddetalhe) { this.iddetalhe = iddetalhe; }

    public int getIdbatismo() { return idbatismo; }
    public void setIdbatismo(int idbatismo) { this.idbatismo = idbatismo; }

    public int getIdcrente() { return idcrente; }
    public void setIdcrente(int idcrente) { this.idcrente = idcrente; }

    public String getNomeCrente() { return nomeCrente; }
    public void setNomeCrente(String nomeCrente) { this.nomeCrente = nomeCrente; }

    public String getPadrinho() { return padrinho; }
    public void setPadrinho(String padrinho) { this.padrinho = padrinho; }

    public String getMadrinha() { return madrinha; }
    public void setMadrinha(String madrinha) { this.madrinha = madrinha; }

    public boolean isConfirmado() { return confirmado; }
    public void setConfirmado(boolean confirmado) { this.confirmado = confirmado; }
}