package com.gim.backend.controller;

import com.gim.backend.dto.EjercicioRequestDTO;
import com.gim.backend.model.Ejercicio;
import com.gim.backend.service.EjercicioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ejercicios")
@RequiredArgsConstructor
public class EjercicioController {

    private final EjercicioService ejercicioService;

    @PostMapping
    public ResponseEntity<Ejercicio> crearEjercicio(@RequestBody EjercicioRequestDTO requestDTO) {
        Ejercicio ejercicio = ejercicioService.crearEjercicio(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(ejercicio);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Ejercicio> obtenerEjercicio(@PathVariable Long id) {
        Ejercicio ejercicio = ejercicioService.obtenerPorId(id);
        return ResponseEntity.ok(ejercicio);
    }

    @GetMapping
    public ResponseEntity<List<Ejercicio>> obtenerTodosEjercicios() {
        List<Ejercicio> ejercicios = ejercicioService.obtenerTodos();
        return ResponseEntity.ok(ejercicios);
    }

    @GetMapping("/grupo/{grupoMuscular}")
    public ResponseEntity<List<Ejercicio>> buscarPorGrupoMuscular(@PathVariable String grupoMuscular) {
        List<Ejercicio> ejercicios = ejercicioService.buscarPorGrupoMuscular(grupoMuscular);
        return ResponseEntity.ok(ejercicios);
    }

    @GetMapping("/buscar")
    public ResponseEntity<List<Ejercicio>> buscarPorNombre(@RequestParam String nombre) {
        List<Ejercicio> ejercicios = ejercicioService.buscarPorNombre(nombre);
        return ResponseEntity.ok(ejercicios);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Ejercicio> actualizarEjercicio(
            @PathVariable Long id,
            @RequestBody EjercicioRequestDTO requestDTO) {
        Ejercicio ejercicio = ejercicioService.actualizarEjercicio(id, requestDTO);
        return ResponseEntity.ok(ejercicio);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarEjercicio(@PathVariable Long id) {
        ejercicioService.eliminarEjercicio(id);
        return ResponseEntity.noContent().build();
    }
}
