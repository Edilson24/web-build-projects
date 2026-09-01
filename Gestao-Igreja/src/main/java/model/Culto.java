package model;

import java.sql.Time;

public class Culto {
    private int idculto;
    private String diaSemana;
    private Time horarioInicio;
    private Time horarioFim;
    private String descricao;

    public Culto() {}

    public Culto(int idculto, String diaSemana, Time horarioInicio, Time horarioFim, String descricao) {
        this.idculto = idculto;
        this.diaSemana = diaSemana;
        this.horarioInicio = horarioInicio;
        this.horarioFim = horarioFim;
        this.descricao = descricao;
    }

    // Getters e Setters
    public int getIdculto() { return idculto; }
    public void setIdculto(int idculto) { this.idculto = idculto; }

    public String getDiaSemana() { return diaSemana; }
    public void setDiaSemana(String diaSemana) { this.diaSemana = diaSemana; }

    public Time getHorarioInicio() { return horarioInicio; }
    public void setHorarioInicio(Time horarioInicio) { this.horarioInicio = horarioInicio; }

    public Time getHorarioFim() { return horarioFim; }
    public void setHorarioFim(Time horarioFim) { this.horarioFim = horarioFim; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
}