import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/login_dto.dart';
import '../models/usuario.dart';

class AuthController {
  static final AuthController instance = AuthController._();
  AuthController._();

  // login: retorna Usuario em caso de sucesso (ou lança)
  Future<Usuario?> login(String email, String senha) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/login");
    final body = jsonEncode(LoginDto(email: email, senha: senha).toJson());

    final resp = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final map = jsonDecode(resp.body);
      // espera que o backend retorne o usuário (ou { user: {...} , token: '...'} )
      final userJson = map['user'] ?? map;
      final usuario = Usuario.fromJson(userJson);
      // salva id localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ft_usuario_logado', usuario.id);
      // opcional: salvar token se existir
      if (map['token'] != null) await prefs.setString('ft_token', map['token']);
      return usuario;
    } else {
      return null;
    }
  }

  // registro: retorna true se criado
  Future<bool> register(Usuario u) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/usuarios");
    final resp = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(u.toJson()));
    return resp.statusCode == 201 || resp.statusCode == 200;
  }

  // logout: remove credenciais locais
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ft_usuario_logado');
    await prefs.remove('ft_token');
  }

  // util: pega id do usuario logado (SharedPreferences)
  Future<String?> getUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ft_usuario_logado');
  }
}
