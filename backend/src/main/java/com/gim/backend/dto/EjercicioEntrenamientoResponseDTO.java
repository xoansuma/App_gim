package com.gim.backend.dto;

import lombok.Data;
import java.util.List;

@Data
public class EjercicioEntrenamientoResponseDTO {
    private Long id;
    private Long ejercicioId;
    private String ejercicioNombre;
    private String grupoMuscular;
    private Integer orden;
    private String notas;
    private List<SerieResponseDTO> series;
}
