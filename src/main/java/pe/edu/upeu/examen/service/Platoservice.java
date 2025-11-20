package pe.edu.upeu.examen.service;


import pe.edu.upeu.examen.entities.Plato;

import java.util.List;

public interface Platoservice {
    List<Plato> listar();
    Plato buscarPorId(Long id);
    Plato guardar(Plato plato);
    void eliminar(Long id);
}
