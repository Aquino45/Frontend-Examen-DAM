import 'package:damfron/data/models/plato.dart';
import 'package:damfron/data/models/cliente.dart';
import 'package:damfron/data/service/api_service.dart';
import 'package:flutter/material.dart';



class NuevoPedidoScreen extends StatefulWidget {
  const NuevoPedidoScreen({super.key});

  @override
  State<NuevoPedidoScreen> createState() => _NuevoPedidoScreenState();
}

class _NuevoPedidoScreenState extends State<NuevoPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controladores y Variables de Estado
  final TextEditingController _mesaController = TextEditingController();
  int? _selectedClienteId;
  int? _selectedPlatoId;
  
  // Listas para los Dropdowns
  List<Cliente> _clientes = [];
  List<Plato> _platos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // Cargamos Clientes y Platos al mismo tiempo para llenar las listas
  void _cargarDatos() async {
    try {
      final clientesData = await _apiService.getClientes();
      final platosData = await _apiService.getPlatos();
      setState(() {
        _clientes = clientesData;
        _platos = platosData;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando datos: $e")),
      );
    }
  }

  void _guardarPedido() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool exito = await _apiService.crearPedido(
        _mesaController.text,
        _selectedClienteId!,
        _selectedPlatoId!,
      );

      setState(() => _isLoading = false);

      if (mounted) { // Verificamos si la pantalla sigue activa
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Pedido creado con éxito!"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // Volver atrás
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al guardar el pedido"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Pedido")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      "Detalles de la Orden",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // 1. Input MESA
                    TextFormField(
                      controller: _mesaController,
                      decoration: InputDecoration(
                        labelText: "Número de Mesa",
                        prefixIcon: const Icon(Icons.table_restaurant),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value!.isEmpty ? "Ingresa la mesa" : null,
                    ),
                    const SizedBox(height: 20),

                    // 2. Dropdown CLIENTE
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Seleccionar Cliente",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      value: _selectedClienteId,
                      items: _clientes.map((cliente) {
                        return DropdownMenuItem(
                          value: cliente.id,
                          child: Text(cliente.nombre),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedClienteId = value),
                      validator: (value) => value == null ? "Selecciona un cliente" : null,
                    ),
                    const SizedBox(height: 20),

                    // 3. Dropdown PLATO
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Seleccionar Plato",
                        prefixIcon: const Icon(Icons.restaurant_menu),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      value: _selectedPlatoId,
                      items: _platos.map((plato) {
                        return DropdownMenuItem(
                          value: plato.id,
                          // Mostramos nombre y precio en el dropdown
                          child: Text("${plato.nombre} - S/${plato.precio}"),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedPlatoId = value),
                      validator: (value) => value == null ? "Selecciona un plato" : null,
                    ),
                    const SizedBox(height: 40),

                    // BOTÓN GUARDAR
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _guardarPedido,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text("CONFIRMAR PEDIDO", style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}