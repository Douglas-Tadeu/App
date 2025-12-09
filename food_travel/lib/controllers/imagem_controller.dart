import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class ImagemController {
  // placeholder upload (se backend suportar multipart)
  Future<Map<String, dynamic>?> uploadImagem(String base64Image, {String? filename}) async {
    final resp = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/imagens/upload"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image, 'filename': filename}),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> deletarImagem(String id) async {
    final resp = await http.delete(Uri.parse("${ApiConfig.baseUrl}/imagens/$id"));
    return resp.statusCode == 200;
  }
}
