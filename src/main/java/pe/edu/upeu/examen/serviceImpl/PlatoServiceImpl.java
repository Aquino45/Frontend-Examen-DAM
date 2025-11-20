package pe.edu.upeu.examen.serviceImpl;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import pe.edu.upeu.examen.entities.Plato;
import pe.edu.upeu.examen.repository.PlatoRepository;
import pe.edu.upeu.examen.service.Platoservice;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PlatoServiceImpl implements Platoservice {

    private final PlatoRepository repo;

    @Override
    public List<Plato> listar() {
        return repo.findAll();
    }

    @Override
    public Plato buscarPorId(Long id) {
        return repo.findById(id).orElse(null);
    }

    @Override
    public Plato guardar(Plato plato) {
        return repo.save(plato);
    }

    @Override
    public void eliminar(Long id) {
        repo.deleteById(id);
    }
}

