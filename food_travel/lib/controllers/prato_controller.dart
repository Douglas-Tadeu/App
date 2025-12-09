import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class PratoController {
  Future<List<dynamic>> listarPratos(String restauranteId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/pratos/$restauranteId");

    final response = await http.get(url);
    return jsonDecode(response.body);
  }
}
