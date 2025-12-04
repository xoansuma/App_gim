package com.gim.backend.dto;

import lombok.Data;

@Data
public class EjercicioEntrenamientoRequestDTO {
    private Long entrenamientoId;
    private Long ejercicioId;
    private Integer orden;
    private String notas;
}
