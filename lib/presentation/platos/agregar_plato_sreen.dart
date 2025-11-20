import 'package:flutter/material.dart';
import '../../data/service/api_service.dart'; 

class AgregarPlatoScreen extends StatefulWidget {
  const AgregarPlatoScreen({super.key});

  @override
  State<AgregarPlatoScreen> createState() => _AgregarPlatoScreenState();
}

class _AgregarPlatoScreenState extends State<AgregarPlatoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final ApiService _api = ApiService();
  bool _isLoading = false;

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Convertimos el precio de String a Double
      double precio = double.tryParse(_precioCtrl.text) ?? 0.0;
      
      bool ok = await _api.registrarPlato(_nombreCtrl.text, _descCtrl.text, precio);
      setState(() => _isLoading = false);

      if (mounted) {
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plato registrado")));
          Navigator.pop(context, true); // 'true' indica que se creó algo
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error"), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Plato")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre del Plato", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Descripción", border: OutlineInputBorder()),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _precioCtrl,
                decoration: const InputDecoration(labelText: "Precio (S/)", border: OutlineInputBorder(), prefixText: "S/ "),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _guardar,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator() : const Text("GUARDAR PLATO"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}