package com.gim.backend.controller;

import com.gim.backend.dto.EjercicioEntrenamientoRequestDTO;
import com.gim.backend.dto.EjercicioEntrenamientoResponseDTO;
import com.gim.backend.service.EjercicioEntrenamientoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ejercicios-entrenamientos")
@RequiredArgsConstructor
public class EjercicioEntrenamientoController {

    private final EjercicioEntrenamientoService ejercicioEntrenamientoService;

    @PostMapping
    public ResponseEntity<EjercicioEntrenamientoResponseDTO> agregarEjercicioAEntrenamiento(
            @RequestBody EjercicioEntrenamientoRequestDTO requestDTO) {
        EjercicioEntrenamientoResponseDTO responseDTO = ejercicioEntrenamientoService.agregarEjercicioAEntrenamiento(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EjercicioEntrenamientoResponseDTO> obtenerEjercicioEntrenamiento(@PathVariable Long id) {
        EjercicioEntrenamientoResponseDTO responseDTO = ejercicioEntrenamientoService.obtenerPorId(id);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/entrenamiento/{entrenamientoId}")
    public ResponseEntity<List<EjercicioEntrenamientoResponseDTO>> obtenerEjerciciosPorEntrenamiento(
            @PathVariable Long entrenamientoId) {
        List<EjercicioEntrenamientoResponseDTO> ejercicios = ejercicioEntrenamientoService.obtenerPorEntrenamiento(entrenamientoId);
        return ResponseEntity.ok(ejercicios);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EjercicioEntrenamientoResponseDTO> actualizarEjercicioEntrenamiento(
            @PathVariable Long id,
            @RequestBody EjercicioEntrenamientoRequestDTO requestDTO) {
        EjercicioEntrenamientoResponseDTO responseDTO = ejercicioEntrenamientoService.actualizarEjercicioEntrenamiento(id, requestDTO);
        return ResponseEntity.ok(responseDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarEjercicioEntrenamiento(@PathVariable Long id) {
        ejercicioEntrenamientoService.eliminarEjercicioEntrenamiento(id);
        return ResponseEntity.noContent().build();
    }
}
