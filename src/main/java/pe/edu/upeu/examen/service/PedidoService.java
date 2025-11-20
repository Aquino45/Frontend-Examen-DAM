package pe.edu.upeu.examen.service;

import pe.edu.upeu.examen.dto.PedidoDTO;
import pe.edu.upeu.examen.entities.Pedido;

import java.util.List;

public interface PedidoService {
    List<Pedido> listar();
    Pedido buscarPorId(Long id);
    Pedido guardar(PedidoDTO pedido);
    void eliminar(Long id);
}
