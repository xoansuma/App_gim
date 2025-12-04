package com.gim.backend.service;

import com.gim.backend.dto.EjercicioEntrenamientoRequestDTO;
import com.gim.backend.dto.EjercicioEntrenamientoResponseDTO;
import com.gim.backend.dto.SerieResponseDTO;
import com.gim.backend.model.Ejercicio;
import com.gim.backend.model.EjercicioEntrenamiento;
import com.gim.backend.model.Entrenamiento;
import com.gim.backend.repository.EjercicioEntrenamientoRepository;
import com.gim.backend.repository.EjercicioRepository;
import com.gim.backend.repository.EntrenamientoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EjercicioEntrenamientoService {

    private final EjercicioEntrenamientoRepository ejercicioEntrenamientoRepository;
    private final EntrenamientoRepository entrenamientoRepository;
    private final EjercicioRepository ejercicioRepository;

    @Transactional
    public EjercicioEntrenamientoResponseDTO agregarEjercicioAEntrenamiento(EjercicioEntrenamientoRequestDTO requestDTO) {
        Entrenamiento entrenamiento = entrenamientoRepository.findById(requestDTO.getEntrenamientoId())
                .orElseThrow(() -> new RuntimeException("Entrenamiento no encontrado"));

        Ejercicio ejercicio = ejercicioRepository.findById(requestDTO.getEjercicioId())
                .orElseThrow(() -> new RuntimeException("Ejercicio no encontrado"));

        EjercicioEntrenamiento ejercicioEntrenamiento = new EjercicioEntrenamiento();
        ejercicioEntrenamiento.setEntrenamiento(entrenamiento);
        ejercicioEntrenamiento.setEjercicio(ejercicio);
        ejercicioEntrenamiento.setOrden(requestDTO.getOrden());
        ejercicioEntrenamiento.setNotas(requestDTO.getNotas());

        EjercicioEntrenamiento guardado = ejercicioEntrenamientoRepository.save(ejercicioEntrenamiento);
        return convertirAResponseDTO(guardado);
    }

    public EjercicioEntrenamientoResponseDTO obtenerPorId(Long id) {
        EjercicioEntrenamiento ejercicioEntrenamiento = ejercicioEntrenamientoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ejercicio-Entrenamiento no encontrado"));
        return convertirAResponseDTO(ejercicioEntrenamiento);
    }

    public List<EjercicioEntrenamientoResponseDTO> obtenerPorEntrenamiento(Long entrenamientoId) {
        return ejercicioEntrenamientoRepository.findByEntrenamientoIdOrderByOrdenAsc(entrenamientoId).stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public EjercicioEntrenamientoResponseDTO actualizarEjercicioEntrenamiento(Long id, EjercicioEntrenamientoRequestDTO requestDTO) {
        EjercicioEntrenamiento ejercicioEntrenamiento = ejercicioEntrenamientoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ejercicio-Entrenamiento no encontrado"));

        ejercicioEntrenamiento.setOrden(requestDTO.getOrden());
        ejercicioEntrenamiento.setNotas(requestDTO.getNotas());

        EjercicioEntrenamiento guardado = ejercicioEntrenamientoRepository.save(ejercicioEntrenamiento);
        return convertirAResponseDTO(guardado);
    }

    @Transactional
    public void eliminarEjercicioEntrenamiento(Long id) {
        if (!ejercicioEntrenamientoRepository.existsById(id)) {
            throw new RuntimeException("Ejercicio-Entrenamiento no encontrado");
        }
        ejercicioEntrenamientoRepository.deleteById(id);
    }

    private EjercicioEntrenamientoResponseDTO convertirAResponseDTO(EjercicioEntrenamiento ejercicioEntrenamiento) {
        EjercicioEntrenamientoResponseDTO dto = new EjercicioEntrenamientoResponseDTO();
        dto.setId(ejercicioEntrenamiento.getId());
        dto.setEjercicioId(ejercicioEntrenamiento.getEjercicio().getId());
        dto.setEjercicioNombre(ejercicioEntrenamiento.getEjercicio().getNombre());
        dto.setGrupoMuscular(ejercicioEntrenamiento.getEjercicio().getGrupoMuscular());
        dto.setOrden(ejercicioEntrenamiento.getOrden());
        dto.setNotas(ejercicioEntrenamiento.getNotas());

        List<SerieResponseDTO> seriesDTO = ejercicioEntrenamiento.getSeries().stream()
                .map(serie -> {
                    SerieResponseDTO serieDto = new SerieResponseDTO();
                    serieDto.setId(serie.getId());
                    serieDto.setNumeroSerie(serie.getNumeroSerie());
                    serieDto.setRepeticiones(serie.getRepeticiones());
                    serieDto.setPeso(serie.getPeso());
                    serieDto.setDuracionSegundos(serie.getDuracionSegundos());
                    serieDto.setNotas(serie.getNotas());
                    serieDto.setFechaRegistro(serie.getFechaRegistro());
                    return serieDto;
                })
                .collect(Collectors.toList());

        dto.setSeries(seriesDTO);
        return dto;
    }
}
