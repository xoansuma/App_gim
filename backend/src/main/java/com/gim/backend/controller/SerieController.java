package com.gim.backend.controller;

import com.gim.backend.dto.SerieRequestDTO;
import com.gim.backend.dto.SerieResponseDTO;
import com.gim.backend.service.SerieService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/series")
@RequiredArgsConstructor
public class SerieController {

    private final SerieService serieService;

    @PostMapping
    public ResponseEntity<SerieResponseDTO> agregarSerie(@RequestBody SerieRequestDTO requestDTO) {
        SerieResponseDTO responseDTO = serieService.agregarSerie(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<SerieResponseDTO> obtenerSerie(@PathVariable Long id) {
        SerieResponseDTO responseDTO = serieService.obtenerPorId(id);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/ejercicio-entrenamiento/{ejercicioEntrenamientoId}")
    public ResponseEntity<List<SerieResponseDTO>> obtenerSeriesPorEjercicioEntrenamiento(
            @PathVariable Long ejercicioEntrenamientoId) {
        List<SerieResponseDTO> series = serieService.obtenerPorEjercicioEntrenamiento(ejercicioEntrenamientoId);
        return ResponseEntity.ok(series);
    }

    @PutMapping("/{id}")
    public ResponseEntity<SerieResponseDTO> actualizarSerie(
            @PathVariable Long id,
            @RequestBody SerieRequestDTO requestDTO) {
        SerieResponseDTO responseDTO = serieService.actualizarSerie(id, requestDTO);
        return ResponseEntity.ok(responseDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarSerie(@PathVariable Long id) {
        serieService.eliminarSerie(id);
        return ResponseEntity.noContent().build();
    }
}
