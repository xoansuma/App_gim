package com.gim.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SerieResponseDTO {
    private Long id;
    private Integer numeroSerie;
    private Integer repeticiones;
    private Double peso;
    private Integer duracionSegundos;
    private String notas;
    private LocalDateTime fechaRegistro;
}
