package com.gim.backend.service;

import com.gim.backend.dto.EntrenamientoRequestDTO;
import com.gim.backend.dto.EntrenamientoResponseDTO;
import com.gim.backend.dto.EjercicioEntrenamientoResponseDTO;
import com.gim.backend.dto.SerieResponseDTO;
import com.gim.backend.model.Entrenamiento;
import com.gim.backend.model.Usuario;
import com.gim.backend.repository.EntrenamientoRepository;
import com.gim.backend.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EntrenamientoService {

    private final EntrenamientoRepository entrenamientoRepository;
    private final UsuarioRepository usuarioRepository;

    @Transactional
    public EntrenamientoResponseDTO crearEntrenamiento(EntrenamientoRequestDTO requestDTO) {
        Usuario usuario = usuarioRepository.findById(requestDTO.getUsuarioId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Entrenamiento entrenamiento = new Entrenamiento();
        entrenamiento.setNombre(requestDTO.getNombre());
        entrenamiento.setDescripcion(requestDTO.getDescripcion());
        entrenamiento.setUsuario(usuario);
        entrenamiento.setFechaRealizacion(requestDTO.getFechaRealizacion());

        Entrenamiento guardado = entrenamientoRepository.save(entrenamiento);
        return convertirAResponseDTO(guardado);
    }

    public EntrenamientoResponseDTO obtenerPorId(Long id) {
        Entrenamiento entrenamiento = entrenamientoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Entrenamiento no encontrado"));
        return convertirAResponseDTO(entrenamiento);
    }

    public List<EntrenamientoResponseDTO> obtenerPorUsuario(Long usuarioId) {
        return entrenamientoRepository.findByUsuarioIdOrderByFechaRealizacionDesc(usuarioId).stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    public List<EntrenamientoResponseDTO> obtenerTodos() {
        return entrenamientoRepository.findAll().stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public EntrenamientoResponseDTO actualizarEntrenamiento(Long id, EntrenamientoRequestDTO requestDTO) {
        Entrenamiento entrenamiento = entrenamientoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Entrenamiento no encontrado"));

        entrenamiento.setNombre(requestDTO.getNombre());
        entrenamiento.setDescripcion(requestDTO.getDescripcion());
        entrenamiento.setFechaRealizacion(requestDTO.getFechaRealizacion());

        Entrenamiento guardado = entrenamientoRepository.save(entrenamiento);
        return convertirAResponseDTO(guardado);
    }

    @Transactional
    public void eliminarEntrenamiento(Long id) {
        if (!entrenamientoRepository.existsById(id)) {
            throw new RuntimeException("Entrenamiento no encontrado");
        }
        entrenamientoRepository.deleteById(id);
    }

    private EntrenamientoResponseDTO convertirAResponseDTO(Entrenamiento entrenamiento) {
        EntrenamientoResponseDTO dto = new EntrenamientoResponseDTO();
        dto.setId(entrenamiento.getId());
        dto.setNombre(entrenamiento.getNombre());
        dto.setDescripcion(entrenamiento.getDescripcion());
        dto.setFechaCreacion(entrenamiento.getFechaCreacion());
        dto.setFechaRealizacion(entrenamiento.getFechaRealizacion());
        dto.setUsuarioId(entrenamiento.getUsuario().getId());
        dto.setUsuarioNombre(entrenamiento.getUsuario().getNombre());

        List<EjercicioEntrenamientoResponseDTO> ejerciciosDTO = entrenamiento.getEjercicios().stream()
                .map(ej -> {
                    EjercicioEntrenamientoResponseDTO ejDto = new EjercicioEntrenamientoResponseDTO();
                    ejDto.setId(ej.getId());
                    ejDto.setEjercicioId(ej.getEjercicio().getId());
                    ejDto.setEjercicioNombre(ej.getEjercicio().getNombre());
                    ejDto.setGrupoMuscular(ej.getEjercicio().getGrupoMuscular());
                    ejDto.setOrden(ej.getOrden());
                    ejDto.setNotas(ej.getNotas());

                    List<SerieResponseDTO> seriesDTO = ej.getSeries().stream()
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

                    ejDto.setSeries(seriesDTO);
                    return ejDto;
                })
                .collect(Collectors.toList());

        dto.setEjercicios(ejerciciosDTO);
        return dto;
    }
}
