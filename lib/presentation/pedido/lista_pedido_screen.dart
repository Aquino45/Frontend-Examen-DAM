import 'package:flutter/material.dart'; 
import 'package:damfron/data/models/pedido.dart';
import 'package:damfron/data/models/cliente.dart';
import 'package:damfron/data/models/plato.dart';
import 'package:damfron/data/service/api_service.dart';
import 'package:damfron/presentation/pedido/pedido_screen.dart'; // (O nuevo_pedido_screen.dart, revisa tu nombre)

class ListaPedidosScreen extends StatefulWidget {
  const ListaPedidosScreen({super.key});

  @override
  State<ListaPedidosScreen> createState() => _ListaPedidosScreenState();
}

class _ListaPedidosScreenState extends State<ListaPedidosScreen> {
  final ApiService _apiService = ApiService();
  
  // Variable para controlar la carga asíncrona
  late Future<List<dynamic>> _cargaInicial;

  @override
  void initState() {
    super.initState();
    _recargarDatos();
  }

  // Función auxiliar para cargar (y recargar) todo
  void _recargarDatos() {
    setState(() {
      _cargaInicial = Future.wait([
        _apiService.getPedidos(),  // index 0
        _apiService.getClientes(), // index 1
        _apiService.getPlatos(),   // index 2
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos Activos"),
        backgroundColor: Colors.orange, // Mantenemos el tema
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<dynamic>>(
        future: _cargaInicial,
        builder: (context, snapshot) {
          // 1. ESTADO CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } 
          // 2. ESTADO ERROR
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } 
          // 3. ESTADO ÉXITO (DATOS LISTOS)
          else if (snapshot.hasData) {
            
            // Desempaquetamos las 3 listas
            final pedidos = snapshot.data![0] as List<Pedido>;
            final clientes = snapshot.data![1] as List<Cliente>;
            final platos = snapshot.data![2] as List<Plato>;

            if (pedidos.isEmpty) {
              return const Center(child: Text("No hay pedidos registrados."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                // --- LOGICA DE CRUCE DE DATOS (JOIN) ---
                
                // Buscamos el cliente correspondiente
                final cliente = clientes.firstWhere(
                  (c) => c.id == pedido.clienteId, 
                  orElse: () => Cliente(id: 0, nombre: 'Desconocido', telefono: ''),
                );
                
                // Buscamos el plato correspondiente
                final plato = platos.firstWhere(
                  (p) => p.id == pedido.platoId,
                  orElse: () => Plato(id: 0, nombre: 'Plato no encontrado', descripcion: '', precio: 0.0),
                );

                // --- TARJETA DEL PEDIDO ---
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: ListTile(
                    // Icono izquierdo
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(Icons.receipt_long, color: Colors.orange),
                    ),
                    
                    // Título (Mesa y Cliente)
                    title: Text(
                      "Mesa ${pedido.numeroMesa} - ${cliente.nombre}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    
                    // Subtítulo (Plato y Precio)
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Plato: ${plato.nombre}"),
                        Text(
                          "Total: S/ ${plato.precio.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    // Parte Derecha: BOTONES EDITAR Y BORRAR
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Para que no ocupe todo el ancho
                      children: [
                        // 1. Botón Editar
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // Navegamos a NuevoPedidoScreen pasando el pedido actual
                            bool? recargar = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NuevoPedidoScreen(pedidoEditar: pedido),
                              ),
                            );
                            
                            // Si editó y volvió, recargamos la lista
                            if (recargar == true) {
                              _recargarDatos();
                            }
                          },
                        ),
                        
                        // 2. Botón Eliminar
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmarEliminacion(context, pedido.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // Función para mostrar alerta de confirmación
  void _confirmarEliminacion(BuildContext context, int idPedido) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Eliminar Pedido?"),
        content: const Text("Esta acción borrará el pedido permanentemente."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Cerrar sin borrar
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Cerrar alerta
              
              // Llamada a la API
              bool exito = await _apiService.eliminarPedido(idPedido);
              
              if (exito) {
                // Si borró bien, recargamos la pantalla
                _recargarDatos();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pedido eliminado correctamente")),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al eliminar"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}