package pe.edu.upeu.examen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.examen.entities.Plato;

public interface PlatoRepository extends JpaRepository<Plato, Long> {
}
