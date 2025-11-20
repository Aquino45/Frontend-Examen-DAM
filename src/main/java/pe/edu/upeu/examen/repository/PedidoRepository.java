package pe.edu.upeu.examen.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.examen.entities.Pedido;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {
}

