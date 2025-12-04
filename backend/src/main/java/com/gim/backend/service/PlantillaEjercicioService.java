package com.gim.backend.service;

import com.gim.backend.dto.PlantillaEjercicioRequestDTO;
import com.gim.backend.dto.PlantillaEjercicioResponseDTO;
import com.gim.backend.model.Ejercicio;
import com.gim.backend.model.PlantillaEjercicio;
import com.gim.backend.model.PlantillaEntrenamiento;
import com.gim.backend.repository.EjercicioRepository;
import com.gim.backend.repository.PlantillaEjercicioRepository;
import com.gim.backend.repository.PlantillaEntrenamientoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlantillaEjercicioService {

    private final PlantillaEjercicioRepository plantillaEjercicioRepository;
    private final PlantillaEntrenamientoRepository plantillaEntrenamientoRepository;
    private final EjercicioRepository ejercicioRepository;

    @Transactional
    public PlantillaEjercicioResponseDTO agregarEjercicio(PlantillaEjercicioRequestDTO requestDTO) {
        PlantillaEntrenamiento plantilla = plantillaEntrenamientoRepository.findById(requestDTO.getPlantillaId())
                .orElseThrow(() -> new RuntimeException("Plantilla no encontrada"));

        Ejercicio ejercicio = ejercicioRepository.findById(requestDTO.getEjercicioId())
                .orElseThrow(() -> new RuntimeException("Ejercicio no encontrado"));

        PlantillaEjercicio plantillaEjercicio = new PlantillaEjercicio();
        plantillaEjercicio.setPlantilla(plantilla);
        plantillaEjercicio.setEjercicio(ejercicio);
        plantillaEjercicio.setOrden(requestDTO.getOrden());
        plantillaEjercicio.setNotas(requestDTO.getNotas());

        PlantillaEjercicio guardado = plantillaEjercicioRepository.save(plantillaEjercicio);
        return convertirAResponseDTO(guardado);
    }

    public PlantillaEjercicioResponseDTO obtenerPorId(Long id) {
        PlantillaEjercicio plantillaEjercicio = plantillaEjercicioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("PlantillaEjercicio no encontrado"));
        return convertirAResponseDTO(plantillaEjercicio);
    }

    public List<PlantillaEjercicioResponseDTO> obtenerPorPlantilla(Long plantillaId) {
        return plantillaEjercicioRepository.findByPlantillaIdOrderByOrden(plantillaId).stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public void eliminar(Long id) {
        if (!plantillaEjercicioRepository.existsById(id)) {
            throw new RuntimeException("PlantillaEjercicio no encontrado");
        }
        plantillaEjercicioRepository.deleteById(id);
    }

    private PlantillaEjercicioResponseDTO convertirAResponseDTO(PlantillaEjercicio plantillaEjercicio) {
        PlantillaEjercicioResponseDTO dto = new PlantillaEjercicioResponseDTO();
        dto.setId(plantillaEjercicio.getId());
        dto.setPlantillaId(plantillaEjercicio.getPlantilla().getId());
        dto.setEjercicioId(plantillaEjercicio.getEjercicio().getId());
        dto.setEjercicioNombre(plantillaEjercicio.getEjercicio().getNombre());
        dto.setEjercicioGrupoMuscular(plantillaEjercicio.getEjercicio().getGrupoMuscular());
        dto.setOrden(plantillaEjercicio.getOrden());
        dto.setNotas(plantillaEjercicio.getNotas());
        return dto;
    }
}
