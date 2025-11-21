import 'package:damfron/data/models/pedido.dart';
import 'package:damfron/data/models/plato.dart';
import 'package:damfron/data/models/cliente.dart';
import 'package:damfron/data/service/api_service.dart';
import 'package:flutter/material.dart';



class NuevoPedidoScreen extends StatefulWidget {
final Pedido? pedidoEditar; // <--- NUEVO: Si esto no es null, estamos editando

  const NuevoPedidoScreen({super.key, this.pedidoEditar});

  @override
  State<NuevoPedidoScreen> createState() => _NuevoPedidoScreenState();
}

class _NuevoPedidoScreenState extends State<NuevoPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _mesaController = TextEditingController();
  int? _selectedClienteId;
  int? _selectedPlatoId;
  
  List<Cliente> _clientes = [];
  List<Plato> _platos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    try {
      // Cargamos listas para los dropdowns
      final clientesData = await _apiService.getClientes();
      final platosData = await _apiService.getPlatos();

      setState(() {
        _clientes = clientesData;
        _platos = platosData;
        
        // --- LOGICA DE EDICIÓN ---
        if (widget.pedidoEditar != null) {
          // Si estamos editando, rellenamos los campos con los datos que vienen
          _mesaController.text = widget.pedidoEditar!.numeroMesa.toString();
          _selectedClienteId = widget.pedidoEditar!.clienteId;
          _selectedPlatoId = widget.pedidoEditar!.platoId;
        }
        // -------------------------
        
        _isLoading = false;
      });
    } catch (e) {
      // Manejo de error simple
      setState(() => _isLoading = false);
    }
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool exito;

      if (widget.pedidoEditar == null) {
        // MODO CREAR
        exito = await _apiService.crearPedido(
          _mesaController.text,
          _selectedClienteId!,
          _selectedPlatoId!,
        );
      } else {
        // MODO EDITAR (Usamos el ID del pedido original)
        exito = await _apiService.editarPedido(
          widget.pedidoEditar!.id,
          _mesaController.text,
          _selectedClienteId!,
          _selectedPlatoId!,
        );
      }

      setState(() => _isLoading = false);

      if (mounted) {
        if (exito) {
          Navigator.pop(context, true); // Retornamos 'true' para recargar la lista anterior
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al guardar"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cambiamos el título según el modo
    final titulo = widget.pedidoEditar == null ? "Nuevo Pedido" : "Editar Pedido #${widget.pedidoEditar!.id}";

    return Scaffold(
      appBar: AppBar(title: Text(titulo), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Input MESA
                    TextFormField(
                      controller: _mesaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Número de Mesa",
                        prefixIcon: Icon(Icons.table_restaurant),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 20),

                    // Dropdown CLIENTE
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Cliente",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedClienteId,
                      items: _clientes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
                      onChanged: (v) => setState(() => _selectedClienteId = v),
                      validator: (v) => v == null ? "Requerido" : null,
                    ),
                    const SizedBox(height: 20),

                    // Dropdown PLATO
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Plato",
                        prefixIcon: Icon(Icons.restaurant_menu),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedPlatoId,
                      items: _platos.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nombre))).toList(),
                      onChanged: (v) => setState(() => _selectedPlatoId = v),
                      validator: (v) => v == null ? "Requerido" : null,
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _guardar,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                        icon: const Icon(Icons.save),
                        label: Text(widget.pedidoEditar == null ? "CREAR" : "ACTUALIZAR"),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}