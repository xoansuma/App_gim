package com.gim.backend.dto;

import lombok.Data;

@Data
public class UsuarioRequestDTO {
    private String email;
    private String nombre;
    private String password;
}
