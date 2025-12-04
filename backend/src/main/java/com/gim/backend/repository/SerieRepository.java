package com.gim.backend.repository;

import com.gim.backend.model.Serie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SerieRepository extends JpaRepository<Serie, Long> {
    List<Serie> findByEjercicioEntrenamientoIdOrderByNumeroSerieAsc(Long ejercicioEntrenamientoId);
}
