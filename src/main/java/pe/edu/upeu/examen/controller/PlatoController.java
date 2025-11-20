package pe.edu.upeu.examen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.examen.entities.Plato;
import pe.edu.upeu.examen.service.Platoservice;

import java.util.List;

@RestController
@RequestMapping("/api/platos")
@RequiredArgsConstructor
public class PlatoController {

    private final Platoservice service;

    @GetMapping
    public List<Plato> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public Plato obtener(@PathVariable Long id) {
        return service.buscarPorId(id);
    }

    @PostMapping
    public Plato crear(@RequestBody Plato plato) {
        return service.guardar(plato);
    }

    @PutMapping("/{id}")
    public Plato actualizar(@PathVariable Long id, @RequestBody Plato plato) {
        plato.setId(id);
        return service.guardar(plato);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Long id) {
        service.eliminar(id);
    }
}