package com.gim.backend.controller;

import com.gim.backend.dto.PlantillaEntrenamientoRequestDTO;
import com.gim.backend.dto.PlantillaEntrenamientoResponseDTO;
import com.gim.backend.service.PlantillaEntrenamientoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/plantillas")
@RequiredArgsConstructor
public class PlantillaEntrenamientoController {

    private final PlantillaEntrenamientoService plantillaService;

    @PostMapping
    public ResponseEntity<PlantillaEntrenamientoResponseDTO> crearPlantilla(@RequestBody PlantillaEntrenamientoRequestDTO requestDTO) {
        PlantillaEntrenamientoResponseDTO responseDTO = plantillaService.crearPlantilla(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlantillaEntrenamientoResponseDTO> obtenerPlantilla(@PathVariable Long id) {
        PlantillaEntrenamientoResponseDTO responseDTO = plantillaService.obtenerPorId(id);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<PlantillaEntrenamientoResponseDTO>> obtenerPlantillasPorUsuario(@PathVariable Long usuarioId) {
        List<PlantillaEntrenamientoResponseDTO> plantillas = plantillaService.obtenerPorUsuario(usuarioId);
        return ResponseEntity.ok(plantillas);
    }

    @GetMapping
    public ResponseEntity<List<PlantillaEntrenamientoResponseDTO>> obtenerTodasPlantillas() {
        List<PlantillaEntrenamientoResponseDTO> plantillas = plantillaService.obtenerTodas();
        return ResponseEntity.ok(plantillas);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PlantillaEntrenamientoResponseDTO> actualizarPlantilla(
            @PathVariable Long id,
            @RequestBody PlantillaEntrenamientoRequestDTO requestDTO) {
        PlantillaEntrenamientoResponseDTO responseDTO = plantillaService.actualizarPlantilla(id, requestDTO);
        return ResponseEntity.ok(responseDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPlantilla(@PathVariable Long id) {
        plantillaService.eliminarPlantilla(id);
        return ResponseEntity.noContent().build();
    }
}
