class Pedido {
  final int id;
  final int numeroMesa;
  final int clienteId;
  final int platoId;

  Pedido({
    required this.id,
    required this.numeroMesa,
    required this.clienteId,
    required this.platoId,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    
  
    int cId = 0;
    if (json['cliente_id'] != null) {
      cId = json['cliente_id']; 
    } else if (json['clienteId'] != null) {
      cId = json['clienteId'];  
    } else if (json['cliente'] != null && json['cliente'] is Map) {
      cId = json['cliente']['id'] ?? 0; 
    }


    int pId = 0;
    if (json['plato_id'] != null) {
      pId = json['plato_id'];
    } else if (json['platoId'] != null) {
      pId = json['platoId'];
    } else if (json['plato'] != null && json['plato'] is Map) {
      pId = json['plato']['id'] ?? 0;
    }

    return Pedido(
      id: json['id'] ?? 0,
      numeroMesa: json['numeroMesa'] ?? json['numero_mesa'] ?? 0,
      clienteId: cId, 
      platoId: pId,  
    );
  }
}