package com.gim.backend.model; // Asegúrate que el paquete coincida con tu carpeta

import jakarta.persistence.Entity; // Importa las herramientas de JPA
import jakarta.persistence.GeneratedValue; // Esto nos ahorra escribir getters y setters
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data // Gracias a Lombok, no hace falta escribir getNombre(), setNombre()...
@Table(name = "ejercicios") // Así se llamará la tabla en Postgres
public class Ejercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;
    private String grupoMuscular;
}