package pe.edu.upeu.examen.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.examen.entities.Cliente;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {
}

