import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthController {
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "senha": senha}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": "Erro no login: ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Erro de conexão: $e"};
    }
  }

  Future<Map<String, dynamic>> register(String nome, String email, String senha) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nome": nome, "email": email, "senha": senha}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Garante que 'success' e 'message' existam
        return {
          "success": body["success"] ?? true,
          "message": body["message"] ?? "Conta criada com sucesso!"
        };
      } else {
        return {"success": false, "message": "Erro no cadastro: ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Erro de conexão: $e"};
    }
  }
}
