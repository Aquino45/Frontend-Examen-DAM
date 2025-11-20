package pe.edu.upeu.examen.serviceImpl;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import pe.edu.upeu.examen.entities.Cliente;
import pe.edu.upeu.examen.repository.ClienteRepository;
import pe.edu.upeu.examen.service.ClienteService;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClienteServiceImpl implements ClienteService {

    private final ClienteRepository repo;

    @Override
    public List<Cliente> listar() {
        return repo.findAll();
    }

    @Override
    public Cliente buscarPorId(Long id) {
        return repo.findById(id).orElse(null);
    }

    @Override
    public Cliente guardar(Cliente cliente) {
        return repo.save(cliente);
    }

    @Override
    public void eliminar(Long id) {
        repo.deleteById(id);
    }
}

