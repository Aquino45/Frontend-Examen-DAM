package pe.edu.upeu.examen.service;

import pe.edu.upeu.examen.entities.Cliente;

import java.util.List;

public interface ClienteService {
    List<Cliente> listar();
    Cliente buscarPorId(Long id);
    Cliente guardar(Cliente cliente);
    void eliminar(Long id);
}
