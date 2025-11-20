package pe.edu.upeu.examen.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "plato")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Plato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;

    private String descripcion;

    private Double precio;
}