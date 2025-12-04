package com.gim.backend.service;

import com.gim.backend.dto.UsuarioRequestDTO;
import com.gim.backend.dto.UsuarioResponseDTO;
import com.gim.backend.model.Usuario;
import com.gim.backend.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    @Transactional
    public UsuarioResponseDTO crearUsuario(UsuarioRequestDTO requestDTO) {
        if (usuarioRepository.existsByEmail(requestDTO.getEmail())) {
            throw new RuntimeException("El email ya está registrado");
        }

        Usuario usuario = new Usuario();
        usuario.setEmail(requestDTO.getEmail());
        usuario.setNombre(requestDTO.getNombre());
        usuario.setPassword(requestDTO.getPassword()); // En producción, hashear password

        Usuario guardado = usuarioRepository.save(usuario);
        return convertirAResponseDTO(guardado);
    }

    public UsuarioResponseDTO obtenerPorId(Long id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return convertirAResponseDTO(usuario);
    }

    public UsuarioResponseDTO obtenerPorEmail(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return convertirAResponseDTO(usuario);
    }

    public List<UsuarioResponseDTO> obtenerTodos() {
        return usuarioRepository.findAll().stream()
                .map(this::convertirAResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public UsuarioResponseDTO actualizarUsuario(Long id, UsuarioRequestDTO requestDTO) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        usuario.setNombre(requestDTO.getNombre());
        if (!usuario.getEmail().equals(requestDTO.getEmail())) {
            if (usuarioRepository.existsByEmail(requestDTO.getEmail())) {
                throw new RuntimeException("El email ya está registrado");
            }
            usuario.setEmail(requestDTO.getEmail());
        }

        Usuario guardado = usuarioRepository.save(usuario);
        return convertirAResponseDTO(guardado);
    }

    @Transactional
    public void eliminarUsuario(Long id) {
        if (!usuarioRepository.existsById(id)) {
            throw new RuntimeException("Usuario no encontrado");
        }
        usuarioRepository.deleteById(id);
    }

    public UsuarioResponseDTO login(String email, String password) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Credenciales inválidas"));

        if (!usuario.getPassword().equals(password)) {
            throw new RuntimeException("Credenciales inválidas");
        }

        return convertirAResponseDTO(usuario);
    }

    private UsuarioResponseDTO convertirAResponseDTO(Usuario usuario) {
        UsuarioResponseDTO dto = new UsuarioResponseDTO();
        dto.setId(usuario.getId());
        dto.setEmail(usuario.getEmail());
        dto.setNombre(usuario.getNombre());
        dto.setFechaRegistro(usuario.getFechaRegistro());
        return dto;
    }
}
