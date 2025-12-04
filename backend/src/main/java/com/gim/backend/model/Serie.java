package com.gim.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "series")
public class Serie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ejercicio_entrenamiento_id", nullable = false)
    private EjercicioEntrenamiento ejercicioEntrenamiento;

    @Column(nullable = false)
    private Integer numeroSerie; // 1, 2, 3, etc.

    @Column(nullable = false)
    private Integer repeticiones;

    private Double peso; // Peso utilizado en kg

    private Integer duracionSegundos; // Para ejercicios de tiempo (plancha, etc.)

    private String notas;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    @PrePersist
    protected void onCreate() {
        fechaRegistro = LocalDateTime.now();
    }
}
