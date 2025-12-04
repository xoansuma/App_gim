package com.gim.backend.repository;

import com.gim.backend.model.Entrenamiento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EntrenamientoRepository extends JpaRepository<Entrenamiento, Long> {
    List<Entrenamiento> findByUsuarioIdOrderByFechaRealizacionDesc(Long usuarioId);
    List<Entrenamiento> findByUsuarioId(Long usuarioId);
}
