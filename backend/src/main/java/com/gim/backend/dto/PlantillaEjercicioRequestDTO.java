package com.gim.backend.dto;

import lombok.Data;

@Data
public class PlantillaEjercicioRequestDTO {
    private Long plantillaId;
    private Long ejercicioId;
    private Integer orden;
    private String notas;
}
