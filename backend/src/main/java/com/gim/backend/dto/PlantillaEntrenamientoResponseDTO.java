package com.gim.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class PlantillaEntrenamientoResponseDTO {
    private Long id;
    private String nombre;
    private String descripcion;
    private LocalDateTime fechaCreacion;
    private Long usuarioId;
    private String usuarioNombre;
    private List<PlantillaEjercicioResponseDTO> ejercicios;
}
