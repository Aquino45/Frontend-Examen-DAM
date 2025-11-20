import 'package:damfron/presentation/pedido/lista_pedido_screen.dart';
import 'package:flutter/material.dart';

// --- MODELOS Y SERVICIOS ---
import 'package:damfron/data/models/plato.dart'; 
import 'package:damfron/data/service/api_service.dart';


import 'package:damfron/presentation/cliente/agregar_cliente_screen.dart';
import 'package:damfron/presentation/platos/agregar_plato_sreen.dart'; 
import 'package:damfron/presentation/pedido/pedido_screen.dart';

class PlatosScreen extends StatefulWidget {
  const PlatosScreen({super.key});

  @override
  State<PlatosScreen> createState() => _PlatosScreenState();
}

class _PlatosScreenState extends State<PlatosScreen> {
  late Future<List<Plato>> _listaPlatos;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _cargarPlatos();
  }


  void _cargarPlatos() {
    setState(() {
      _listaPlatos = _apiService.getPlatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú del Día"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Administrador"),
              accountEmail: Text("admin@restaurante.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.orange),
              ),
              decoration: BoxDecoration(color: Colors.orange),
            ),
            

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Registrar Nuevo Cliente'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgregarClienteScreen()),
                );
              },
            ),


            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Registrar Nuevo Plato'),
              onTap: () async {
                Navigator.pop(context); 
                

                final resultado = await Navigator.push(
                  context,
                 
                  MaterialPageRoute(builder: (context) => const AgregarPlatoScreen()), 
                );


                if (resultado == true) {
                  _cargarPlatos();
                }
              },
            ),

            const Divider(), 


            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.blueGrey),
              title: const Text('Ver Pedidos Activos', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaPedidosScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<List<Plato>>(
        future: _listaPlatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40, color: Colors.red),
                    const SizedBox(height: 10),
                    Text("Error de conexión:\n${snapshot.error}", textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _cargarPlatos, child: const Text("Reintentar"))
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final platos = snapshot.data!;
            if (platos.isEmpty) {
               return const Center(child: Text("Aún no hay platos registrados."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: platos.length,
              itemBuilder: (context, index) {
                return _buildPlatoCard(platos[index]);
              },
            );
          }
          return const Center(child: Text("No hay datos disponibles"));
        },
      ),

      // 3. BOTÓN FLOTANTE PARA HACER PEDIDO
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NuevoPedidoScreen()),
          );
        },
        label: const Text("Hacer Pedido"),
        icon: const Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
    );
  }

  // TARJETA VISUAL DEL PLATO (Optimizada)
  Widget _buildPlatoCard(Plato plato) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Avatar con inicial
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  plato.nombre.isNotEmpty ? plato.nombre[0].toUpperCase() : "?",
                  style: TextStyle(fontSize: 24, color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plato.nombre,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plato.descripcion,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(

                  "S/ ${plato.precio.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }
}