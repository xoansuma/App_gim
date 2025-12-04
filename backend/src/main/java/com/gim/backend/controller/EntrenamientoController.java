package com.gim.backend.controller;

import com.gim.backend.dto.EntrenamientoRequestDTO;
import com.gim.backend.dto.EntrenamientoResponseDTO;
import com.gim.backend.service.EntrenamientoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/entrenamientos")
@RequiredArgsConstructor
public class EntrenamientoController {

    private final EntrenamientoService entrenamientoService;

    @PostMapping
    public ResponseEntity<EntrenamientoResponseDTO> crearEntrenamiento(@RequestBody EntrenamientoRequestDTO requestDTO) {
        EntrenamientoResponseDTO responseDTO = entrenamientoService.crearEntrenamiento(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EntrenamientoResponseDTO> obtenerEntrenamiento(@PathVariable Long id) {
        EntrenamientoResponseDTO responseDTO = entrenamientoService.obtenerPorId(id);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<EntrenamientoResponseDTO>> obtenerEntrenamientosPorUsuario(@PathVariable Long usuarioId) {
        List<EntrenamientoResponseDTO> entrenamientos = entrenamientoService.obtenerPorUsuario(usuarioId);
        return ResponseEntity.ok(entrenamientos);
    }

    @GetMapping
    public ResponseEntity<List<EntrenamientoResponseDTO>> obtenerTodosEntrenamientos() {
        List<EntrenamientoResponseDTO> entrenamientos = entrenamientoService.obtenerTodos();
        return ResponseEntity.ok(entrenamientos);
    }

    @PutMapping("/{id}")
    public ResponseEntity<EntrenamientoResponseDTO> actualizarEntrenamiento(
            @PathVariable Long id,
            @RequestBody EntrenamientoRequestDTO requestDTO) {
        EntrenamientoResponseDTO responseDTO = entrenamientoService.actualizarEntrenamiento(id, requestDTO);
        return ResponseEntity.ok(responseDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarEntrenamiento(@PathVariable Long id) {
        entrenamientoService.eliminarEntrenamiento(id);
        return ResponseEntity.noContent().build();
    }
}
