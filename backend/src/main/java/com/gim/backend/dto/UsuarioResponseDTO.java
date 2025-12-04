package com.gim.backend.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UsuarioResponseDTO {
    private Long id;
    private String email;
    private String nombre;
    private LocalDateTime fechaRegistro;
}
