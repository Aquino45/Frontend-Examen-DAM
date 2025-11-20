import 'package:flutter/material.dart';
import '../../data/models/pedido.dart';
import '../../data/models/cliente.dart';
import '../../data/models/plato.dart';
import '../../data/service/api_service.dart';

class ListaPedidosScreen extends StatefulWidget {
  const ListaPedidosScreen({super.key});

  @override
  State<ListaPedidosScreen> createState() => _ListaPedidosScreenState();
}

class _ListaPedidosScreenState extends State<ListaPedidosScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _cargaInicial;

  @override
  void initState() {
    super.initState();
    _cargaInicial = Future.wait([
      _apiService.getPedidos(),  // [0]
      _apiService.getClientes(), // [1]
      _apiService.getPlatos(),   // [2]
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pedidos Activos")),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<dynamic>>(
        future: _cargaInicial,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            
            // 1. OBTENER LISTAS
            final pedidos = snapshot.data![0] as List<Pedido>;
            final clientes = snapshot.data![1] as List<Cliente>;
            final platos = snapshot.data![2] as List<Plato>;

            if (pedidos.isEmpty) return const Center(child: Text("No hay pedidos."));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                // --- ZONA DE DEBUG (Mira tu consola) ---
                print("Procesando Pedido #${pedido.id} | Busca ClienteID: ${pedido.clienteId} | Busca PlatoID: ${pedido.platoId}");
                // --------------------------------------

                // 2. BUSCAR EL CLIENTE (JOIN)
                // firstWhere busca en la lista 'clientes' alguien que tenga el mismo ID
                final cliente = clientes.firstWhere(
                  (c) => c.id == pedido.clienteId, 
                  orElse: () => Cliente(id: 0, nombre: 'Desconocido', telefono: ''),
                );
                
                // 3. BUSCAR EL PLATO (JOIN)
                final plato = platos.firstWhere(
                  (p) => p.id == pedido.platoId,
                  orElse: () => Plato(id: 0, nombre: '?', descripcion: '', precio: 0.0),
                );

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  // Color de fondo suave dependiendo si se encontró o no
                  color: (cliente.id == 0) ? Colors.red.shade50 : Colors.orange.shade50,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade200,
                      child: const Icon(Icons.receipt, color: Colors.white),
                    ),
                    title: Text(
                      "${pedido.numeroMesa} - ${cliente.nombre}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Pidió: ${plato.nombre}"),
                    trailing: Text(
                      "S/ ${plato.precio.toStringAsFixed(1)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
}