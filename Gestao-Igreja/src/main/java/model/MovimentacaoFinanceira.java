package model;

import java.math.BigDecimal;
import java.sql.Date;

public class MovimentacaoFinanceira {
    private int idmovimentacao;
    private String tipoMovimentacao; // ENTRADA, SAIDA
    private String categoria;        // DIZIMO, ACAO_DE_GRACA, OFERTORIO_COLETIVO, DESPESA
    private BigDecimal valor;
    private Date data;
    private Integer idcrente;
    private String tipoContribuidor; // MEMBRO, VISITANTE_INDIVIDUAL, VISITANTE_GRUPO, ANONIMO
    private String nomeContribuidorExterno;
    private String observacaoNota;
    private int idusuarioRegistro;

    // Display helpers for views
    private String nomeContribuidor;

    public int getIdmovimentacao() { return idmovimentacao; }
    public void setIdmovimentacao(int idmovimentacao) { this.idmovimentacao = idmovimentacao; }

    public String getTipoMovimentacao() { return tipoMovimentacao; }
    public void setTipoMovimentacao(String tipoMovimentacao) { this.tipoMovimentacao = tipoMovimentacao; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public BigDecimal getValor() { return valor; }
    public void setValor(BigDecimal valor) { this.valor = valor; }

    public Date getData() { return data; }
    public void setData(Date data) { this.data = data; }

    public Integer getIdcrente() { return idcrente; }
    public void setIdcrente(Integer idcrente) { this.idcrente = idcrente; }

    public String getTipoContribuidor() { return tipoContribuidor; }
    public void setTipoContribuidor(String tipoContribuidor) { this.tipoContribuidor = tipoContribuidor; }

    public String getNomeContribuidorExterno() { return nomeContribuidorExterno; }
    public void setNomeContribuidorExterno(String nomeContribuidorExterno) { this.nomeContribuidorExterno = nomeContribuidorExterno; }

    public String getObservacaoNota() { return observacaoNota; }
    public void setObservacaoNota(String observacaoNota) { this.observacaoNota = observacaoNota; }

    public int getIdusuarioRegistro() { return idusuarioRegistro; }
    public void setIdusuarioRegistro(int idusuarioRegistro) { this.idusuarioRegistro = idusuarioRegistro; }

    public String getNomeContribuidor() { return nomeContribuidor; }
    public void setNomeContribuidor(String nomeContribuidor) { this.nomeContribuidor = nomeContribuidor; }
}