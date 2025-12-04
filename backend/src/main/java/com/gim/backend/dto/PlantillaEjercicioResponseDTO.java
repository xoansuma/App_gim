package com.gim.backend.dto;

import lombok.Data;

@Data
public class PlantillaEjercicioResponseDTO {
    private Long id;
    private Long plantillaId;
    private Long ejercicioId;
    private String ejercicioNombre;
    private String ejercicioGrupoMuscular;
    private Integer orden;
    private String notas;
}
