package com.gim.backend.service;

import com.gim.backend.dto.EjercicioRequestDTO;
import com.gim.backend.model.Ejercicio;
import com.gim.backend.repository.EjercicioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EjercicioService {

    private final EjercicioRepository ejercicioRepository;

    @Transactional
    public Ejercicio crearEjercicio(EjercicioRequestDTO requestDTO) {
        Ejercicio ejercicio = new Ejercicio();
        ejercicio.setNombre(requestDTO.getNombre());
        ejercicio.setGrupoMuscular(requestDTO.getGrupoMuscular());
        return ejercicioRepository.save(ejercicio);
    }

    public Ejercicio obtenerPorId(Long id) {
        return ejercicioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ejercicio no encontrado"));
    }

    public List<Ejercicio> obtenerTodos() {
        return ejercicioRepository.findAll();
    }

    public List<Ejercicio> buscarPorGrupoMuscular(String grupoMuscular) {
        return ejercicioRepository.findByGrupoMuscular(grupoMuscular);
    }

    public List<Ejercicio> buscarPorNombre(String nombre) {
        return ejercicioRepository.findByNombreContainingIgnoreCase(nombre);
    }

    @Transactional
    public Ejercicio actualizarEjercicio(Long id, EjercicioRequestDTO requestDTO) {
        Ejercicio ejercicio = ejercicioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ejercicio no encontrado"));

        ejercicio.setNombre(requestDTO.getNombre());
        ejercicio.setGrupoMuscular(requestDTO.getGrupoMuscular());

        return ejercicioRepository.save(ejercicio);
    }

    @Transactional
    public void eliminarEjercicio(Long id) {
        if (!ejercicioRepository.existsById(id)) {
            throw new RuntimeException("Ejercicio no encontrado");
        }
        ejercicioRepository.deleteById(id);
    }
}
