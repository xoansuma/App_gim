package com.gim.backend.service;

import com.gim.backend.dto.SerieRequestDTO;
import com.gim.backend.dto.SerieResponseDTO;
import com.gim.backend.model.EjercicioEntrenamiento;
import com.gim.backend.model.Serie;
import com.gim.backend.repository.EjercicioEntrenamientoRepository;
import com.gim.backend.repository.SerieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SerieService {

    private final SerieRepository serieRepository;
    private final EjercicioEntrenamientoRepository ejercicioEntrenamientoRepository;

    @Transactional
    public SerieResponseDTO agregarSerie(SerieRequestDTO requestDTO) {
        EjercicioEntrenamiento ejercicioEntrenamiento = ejercicioEntrenamientoRepository.findById(requestDTO.getEjercicioEntrenamientoId())
                .orElseThrow(() -> new RuntimeException("Ejercicio-Entrenamiento no encontrado"));

        Serie serie = new Serie();
        serie.setEjercicioEntrenamiento(ejercicioEntrenamiento);
        serie.setNumeroSerie(requestDTO.getNumeroSerie());
        serie.setRepeticiones(requestDTO.getRepeticiones());
        serie.setPeso(requestDTO.getPeso());
        serie.setDuracionSegundos(requestDTO.getDuracionSegundos());
        serie.setNotas(requestDTO.getNotas());

        Serie guardada = serieRepository.save(serie);
        return convertirAResponseDTO(guardada);
    }

    public SerieResponseDTO obtenerPorId(Long id) {
        Serie serie = serieRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Serie no encontrada"));
        return convertirAResponseDTO(serie);
    }

    public List<SerieResponseDTO> obtenerPorEjercicioEntrenamiento(Long ejercicioEntrenamientoId) {
        return serieRepository.findByEjercicioEntrenamientoIdOrderByNumeroSerieAsc(ejercicioEntrenamientoId).stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public SerieResponseDTO actualizarSerie(Long id, SerieRequestDTO requestDTO) {
        Serie serie = serieRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Serie no encontrada"));

        serie.setNumeroSerie(requestDTO.getNumeroSerie());
        serie.setRepeticiones(requestDTO.getRepeticiones());
        serie.setPeso(requestDTO.getPeso());
        serie.setDuracionSegundos(requestDTO.getDuracionSegundos());
        serie.setNotas(requestDTO.getNotas());

        Serie guardada = serieRepository.save(serie);
        return convertirAResponseDTO(guardada);
    }

    @Transactional
    public void eliminarSerie(Long id) {
        if (!serieRepository.existsById(id)) {
            throw new RuntimeException("Serie no encontrada");
        }
        serieRepository.deleteById(id);
    }

    private SerieResponseDTO convertirAResponseDTO(Serie serie) {
        SerieResponseDTO dto = new SerieResponseDTO();
        dto.setId(serie.getId());
        dto.setNumeroSerie(serie.getNumeroSerie());
        dto.setRepeticiones(serie.getRepeticiones());
        dto.setPeso(serie.getPeso());
        dto.setDuracionSegundos(serie.getDuracionSegundos());
        dto.setNotas(serie.getNotas());
        dto.setFechaRegistro(serie.getFechaRegistro());
        return dto;
    }
}
