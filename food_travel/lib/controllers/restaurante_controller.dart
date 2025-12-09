import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/restaurante.dart';

class RestauranteController {
  Future<List<Restaurante>> listarRestaurantes() async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/restaurantes"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Restaurante.fromJson(j)).toList();
  }

  Future<Restaurante> buscarRestaurante(String id) async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/restaurantes/$id"));
    return Restaurante.fromJson(jsonDecode(resp.body));
  }

  Future<bool> criarRestaurante(Restaurante r) async {
    final resp = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/restaurantes"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(r.toJson()),
    );
    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  Future<bool> atualizarRestaurante(String id, Restaurante r) async {
    final resp = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/restaurantes/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(r.toJson()),
    );
    return resp.statusCode == 200;
  }

  Future<bool> deletarRestaurante(String id) async {
    final resp = await http.delete(Uri.parse("${ApiConfig.baseUrl}/restaurantes/$id"));
    return resp.statusCode == 200;
  }
}
