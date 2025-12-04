package com.gim.backend.dto;

import lombok.Data;

@Data
public class PlantillaEntrenamientoRequestDTO {
    private String nombre;
    private String descripcion;
    private Long usuarioId;
}
