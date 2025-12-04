package com.gim.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class EntrenamientoResponseDTO {
    private Long id;
    private String nombre;
    private String descripcion;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaRealizacion;
    private Long usuarioId;
    private String usuarioNombre;
    private List<EjercicioEntrenamientoResponseDTO> ejercicios;
}
