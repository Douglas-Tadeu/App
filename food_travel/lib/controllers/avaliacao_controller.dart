import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/avaliacao.dart';

class AvaliacaoController {
  Future<List<Avaliacao>> listarAvaliacoes() async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/avaliacoes"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Avaliacao.fromJson(j)).toList();
  }

  Future<List<Avaliacao>> listarAvaliacoesPorPrato(String pratoId) async {
    final resp = await http.get(Uri.parse("${ApiConfig.baseUrl}/avaliacoes?pratoId=$pratoId"));
    final data = jsonDecode(resp.body);
    return (data as List).map((j) => Avaliacao.fromJson(j)).toList();
  }

  Future<bool> criarAvaliacao(Avaliacao a) async {
    final resp = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/avaliacoes"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  Future<bool> atualizarAvaliacao(String id, Avaliacao a) async {
    final resp = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/avaliacoes/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(a.toJson()),
    );
    return resp.statusCode == 200;
  }

  Future<bool> deletarAvaliacao(String id) async {
    final resp = await http.delete(Uri.parse("${ApiConfig.baseUrl}/avaliacoes/$id"));
    return resp.statusCode == 200;
  }
}
