package com.gim.backend.repository;

import com.gim.backend.model.PlantillaEjercicio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PlantillaEjercicioRepository extends JpaRepository<PlantillaEjercicio, Long> {
    List<PlantillaEjercicio> findByPlantillaIdOrderByOrden(Long plantillaId);
}
