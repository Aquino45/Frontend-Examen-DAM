package pe.edu.upeu.examen.serviceImpl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.examen.dto.PedidoDTO; // Asegúrate de crear esta clase (ver abajo)
import pe.edu.upeu.examen.entities.Cliente;
import pe.edu.upeu.examen.entities.Pedido;
import pe.edu.upeu.examen.entities.Plato;
import pe.edu.upeu.examen.repository.ClienteRepository;
import pe.edu.upeu.examen.repository.PedidoRepository;
import pe.edu.upeu.examen.repository.PlatoRepository;
import pe.edu.upeu.examen.service.PedidoService;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PedidoServiceImpl implements PedidoService {

    private final PedidoRepository repo;
    private final ClienteRepository clienteRepo;
    private final PlatoRepository platoRepo;

    @Override
    @Transactional(readOnly = true)
    public List<Pedido> listar() {
        return repo.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Pedido buscarPorId(Long id) {
        return repo.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Pedido guardar(PedidoDTO pedidoDto) {
        // 1. Creamos la instancia del Pedido
        Pedido pedido = new Pedido();
        pedido.setNumeroMesa(pedidoDto.getNumeroMesa());

        // 2. Buscamos el CLIENTE por el ID que viene del JSON
        Cliente cliente = clienteRepo.findById(pedidoDto.getCliente_id())
                .orElseThrow(() -> new RuntimeException("Error: Cliente no encontrado con ID " + pedidoDto.getCliente_id()));

        // 3. Buscamos el PLATO por el ID que viene del JSON
        Plato plato = platoRepo.findById(pedidoDto.getPlato_id())
                .orElseThrow(() -> new RuntimeException("Error: Plato no encontrado con ID " + pedidoDto.getPlato_id()));

        // 4. Asignamos los objetos encontrados al pedido
        pedido.setCliente(cliente);
        pedido.setPlato(plato);

        // 5. Guardamos
        return repo.save(pedido);
    }

    @Override
    @Transactional
    public void eliminar(Long id) {
        repo.deleteById(id);
    }
}