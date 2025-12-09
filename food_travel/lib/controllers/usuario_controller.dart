import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/usuario.dart';

class UsuarioController {
  Future<List<Usuario>> listarUsuarios() async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/usuarios"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Usuario.fromJson(j)).toList();
  }

  Future<Usuario> buscarUsuario(String id) async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/usuarios/$id"));
    return Usuario.fromJson(jsonDecode(resp.body));
  }

  Future<bool> criarUsuario(Usuario u) async {
    final resp = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/usuarios"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(u.toJson()),
    );
    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  Future<bool> atualizarUsuario(String id, Usuario u) async {
    final resp = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/usuarios/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(u.toJson()),
    );
    return resp.statusCode == 200;
  }

  Future<bool> deletarUsuario(String id) async {
    final resp = await http.delete(Uri.parse("${ApiConfig.baseUrl}/usuarios/$id"));
    return resp.statusCode == 200;
  }
}
