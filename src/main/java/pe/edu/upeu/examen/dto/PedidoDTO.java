package pe.edu.upeu.examen.dto;

import lombok.Data;

@Data
public class PedidoDTO {
    private Integer numeroMesa;
    private Long cliente_id; // El nombre debe coincidir con tu JSON
    private Long plato_id;
}