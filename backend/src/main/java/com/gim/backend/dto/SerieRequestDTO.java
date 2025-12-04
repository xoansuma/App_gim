package com.gim.backend.dto;

import lombok.Data;

@Data
public class SerieRequestDTO {
    private Long ejercicioEntrenamientoId;
    private Integer numeroSerie;
    private Integer repeticiones;
    private Double peso;
    private Integer duracionSegundos;
    private String notas;
}
