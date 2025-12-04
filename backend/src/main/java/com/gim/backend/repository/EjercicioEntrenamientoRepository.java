package com.gim.backend.repository;

import com.gim.backend.model.EjercicioEntrenamiento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface EjercicioEntrenamientoRepository extends JpaRepository<EjercicioEntrenamiento, Long> {
    List<EjercicioEntrenamiento> findByEntrenamientoIdOrderByOrdenAsc(Long entrenamientoId);
}
