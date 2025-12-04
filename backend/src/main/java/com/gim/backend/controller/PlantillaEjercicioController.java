package com.gim.backend.controller;

import com.gim.backend.dto.PlantillaEjercicioRequestDTO;
import com.gim.backend.dto.PlantillaEjercicioResponseDTO;
import com.gim.backend.service.PlantillaEjercicioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/plantillas-ejercicios")
@RequiredArgsConstructor
public class PlantillaEjercicioController {

    private final PlantillaEjercicioService plantillaEjercicioService;

    @PostMapping
    public ResponseEntity<PlantillaEjercicioResponseDTO> agregarEjercicio(@RequestBody PlantillaEjercicioRequestDTO requestDTO) {
        PlantillaEjercicioResponseDTO responseDTO = plantillaEjercicioService.agregarEjercicio(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlantillaEjercicioResponseDTO> obtenerPlantillaEjercicio(@PathVariable Long id) {
        PlantillaEjercicioResponseDTO responseDTO = plantillaEjercicioService.obtenerPorId(id);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/plantilla/{plantillaId}")
    public ResponseEntity<List<PlantillaEjercicioResponseDTO>> obtenerEjerciciosPorPlantilla(@PathVariable Long plantillaId) {
        List<PlantillaEjercicioResponseDTO> ejercicios = plantillaEjercicioService.obtenerPorPlantilla(plantillaId);
        return ResponseEntity.ok(ejercicios);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarEjercicio(@PathVariable Long id) {
        plantillaEjercicioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
