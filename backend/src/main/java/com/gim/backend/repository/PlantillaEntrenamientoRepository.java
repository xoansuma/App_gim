package com.gim.backend.repository;

import com.gim.backend.model.PlantillaEntrenamiento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PlantillaEntrenamientoRepository extends JpaRepository<PlantillaEntrenamiento, Long> {
    List<PlantillaEntrenamiento> findByUsuarioIdOrderByFechaCreacionDesc(Long usuarioId);
    List<PlantillaEntrenamiento> findByUsuarioId(Long usuarioId);
}
