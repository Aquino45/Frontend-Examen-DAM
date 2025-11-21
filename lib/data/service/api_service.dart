import 'package:damfron/data/models/pedido.dart';
import 'package:damfron/data/models/plato.dart'; 
import 'package:damfron/data/models/cliente.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  final String baseUrl = "http://10.0.2.2:8081/api"; 

  // GET: Obtener lista de platos
  Future<List<Plato>> getPlatos() async {
    final response = await http.get(Uri.parse('$baseUrl/platos'));

    if (response.statusCode == 200) {
      // Si Spring responde OK, decodificamos el JSON
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Plato> platos = body.map((dynamic item) => Plato.fromJson(item)).toList();
      return platos;
    } else {
      throw Exception('Fallo al cargar los platos desde Spring');
    }
  }

  Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => Cliente.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar clientes');
    }
  }





  Future<bool> crearPedido(String mesa, int clienteId, int platoId) async {
    

    int? mesaNumero = int.tryParse(mesa);
    if (mesaNumero == null) return false; 

    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "numeroMesa": mesaNumero, 
        "cliente_id": clienteId,  
        "plato_id": platoId,      
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> registrarCliente(String nombre, String telefono) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "telefono": telefono,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // 4. Registrar nuevo Plato
  Future<bool> registrarPlato(String nombre, String descripcion, double precio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/platos'), 
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Pedido>> getPedidos() async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => Pedido.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar pedidos');
    }
  }

  Future<bool> editarPedido(int id, String mesa, int clienteId, int platoId) async {
    int? mesaNumero = int.tryParse(mesa);
    if (mesaNumero == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/pedidos/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "numeroMesa": mesaNumero,
        "cliente_id": clienteId,
        "plato_id": platoId,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> eliminarPedido(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/pedidos/$id'),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }
}