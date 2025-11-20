class Plato {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;

  Plato({required this.id, required this.nombre, required this.descripcion, required this.precio});

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'],
    );
  }
}
