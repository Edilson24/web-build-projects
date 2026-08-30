package model;

public class ParenteDTO {
    private String nome;
    private String grau;

    public ParenteDTO(String nome, String grau) {
        this.nome = nome;
        this.grau = grau;
    }

    public String getNome() { return nome; }
    public String getGrau() { return grau; }
}