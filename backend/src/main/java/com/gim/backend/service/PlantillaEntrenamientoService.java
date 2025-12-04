package com.gim.backend.service;

import com.gim.backend.dto.PlantillaEntrenamientoRequestDTO;
import com.gim.backend.dto.PlantillaEntrenamientoResponseDTO;
import com.gim.backend.dto.PlantillaEjercicioResponseDTO;
import com.gim.backend.model.PlantillaEntrenamiento;
import com.gim.backend.model.Usuario;
import com.gim.backend.repository.PlantillaEntrenamientoRepository;
import com.gim.backend.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlantillaEntrenamientoService {

    private final PlantillaEntrenamientoRepository plantillaRepository;
    private final UsuarioRepository usuarioRepository;

    @Transactional
    public PlantillaEntrenamientoResponseDTO crearPlantilla(PlantillaEntrenamientoRequestDTO requestDTO) {
        Usuario usuario = usuarioRepository.findById(requestDTO.getUsuarioId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        PlantillaEntrenamiento plantilla = new PlantillaEntrenamiento();
        plantilla.setNombre(requestDTO.getNombre());
        plantilla.setDescripcion(requestDTO.getDescripcion());
        plantilla.setUsuario(usuario);

        PlantillaEntrenamiento guardada = plantillaRepository.save(plantilla);
        return convertirAResponseDTO(guardada);
    }

    public PlantillaEntrenamientoResponseDTO obtenerPorId(Long id) {
        PlantillaEntrenamiento plantilla = plantillaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plantilla no encontrada"));
        return convertirAResponseDTO(plantilla);
    }

    public List<PlantillaEntrenamientoResponseDTO> obtenerPorUsuario(Long usuarioId) {
        return plantillaRepository.findByUsuarioIdOrderByFechaCreacionDesc(usuarioId).stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    public List<PlantillaEntrenamientoResponseDTO> obtenerTodas() {
        return plantillaRepository.findAll().stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public PlantillaEntrenamientoResponseDTO actualizarPlantilla(Long id, PlantillaEntrenamientoRequestDTO requestDTO) {
        PlantillaEntrenamiento plantilla = plantillaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plantilla no encontrada"));

        plantilla.setNombre(requestDTO.getNombre());
        plantilla.setDescripcion(requestDTO.getDescripcion());

        PlantillaEntrenamiento guardada = plantillaRepository.save(plantilla);
        return convertirAResponseDTO(guardada);
    }

    @Transactional
    public void eliminarPlantilla(Long id) {
        if (!plantillaRepository.existsById(id)) {
            throw new RuntimeException("Plantilla no encontrada");
        }
        plantillaRepository.deleteById(id);
    }

    private PlantillaEntrenamientoResponseDTO convertirAResponseDTO(PlantillaEntrenamiento plantilla) {
        PlantillaEntrenamientoResponseDTO dto = new PlantillaEntrenamientoResponseDTO();
        dto.setId(plantilla.getId());
        dto.setNombre(plantilla.getNombre());
        dto.setDescripcion(plantilla.getDescripcion());
        dto.setFechaCreacion(plantilla.getFechaCreacion());
        dto.setUsuarioId(plantilla.getUsuario().getId());
        dto.setUsuarioNombre(plantilla.getUsuario().getNombre());

        List<PlantillaEjercicioResponseDTO> ejerciciosDTO = plantilla.getEjercicios().stream()
                .map(ej -> {
                    PlantillaEjercicioResponseDTO ejDto = new PlantillaEjercicioResponseDTO();
                    ejDto.setId(ej.getId());
                    ejDto.setPlantillaId(plantilla.getId());
                    ejDto.setEjercicioId(ej.getEjercicio().getId());
                    ejDto.setEjercicioNombre(ej.getEjercicio().getNombre());
                    ejDto.setEjercicioGrupoMuscular(ej.getEjercicio().getGrupoMuscular());
                    ejDto.setOrden(ej.getOrden());
                    ejDto.setNotas(ej.getNotas());
                    return ejDto;
                })
                .collect(Collectors.toList());

        dto.setEjercicios(ejerciciosDTO);
        return dto;
    }
}
