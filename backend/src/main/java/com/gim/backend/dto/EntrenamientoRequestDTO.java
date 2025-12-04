package com.gim.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class EntrenamientoRequestDTO {
    private String nombre;
    private String descripcion;
    private Long usuarioId;
    private LocalDateTime fechaRealizacion;
}
