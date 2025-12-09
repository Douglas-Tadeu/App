import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/favorito.dart';

class FavoritoController {
  Future<List<Favorito>> listarFavoritos() async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/favoritos"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Favorito.fromJson(j)).toList();
  }

  Future<List<Favorito>> listarFavoritosPorUsuario(String usuarioId) async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/favoritos?usuarioId=$usuarioId"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Favorito.fromJson(j)).toList();
  }

  Future<bool> criarFavorito(Favorito f) async {
    final resp = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/favoritos"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(f.toJson()),
    );
    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  Future<bool> deletarFavorito(String id) async {
    final resp = await http.delete(Uri.parse("${ApiConfig.baseUrl}/favoritos/$id"));
    return resp.statusCode == 200;
  }
}
