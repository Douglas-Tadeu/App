import 'dart:async';
import '../../models/prato.dart';
import '../../models/restaurante.dart';
import '../../models/favorito.dart';
import '../../models/avaliacao.dart';

class FoodTravelService {
  // ---------- SINGLETON ----------
  static final FoodTravelService _instance = FoodTravelService._interno();
  factory FoodTravelService() => _instance;

  FoodTravelService._interno() {
    if (_restaurantes.isEmpty) {
      _restaurantes.add(
        Restaurante(
          id: 'r1',
          nome: 'Favoritos do Douglas',
          endereco: 'Endereço: Qualquer lugar menos onde deviam me achar.',
          usuarioId: 'owner1',
          imageUrl: 'https://sebrae.com.br/Sebrae/Portal%20Sebrae/Artigos/Imagens/imagem_alimentos_e_bebidas_comida-boa-tem-que-ficar-bem-na-foto-dicas-para-o-seu-restaurante_shutterstock_1141124684.jpg',
        ),
      );
    }
  }

  // ---------- DADOS EM MEMÓRIA ----------
  final List<Prato> _pratos = [];
  final List<Restaurante> _restaurantes = [];
  final List<Favorito> _favoritos = [];
  final List<Avaliacao> _avaliacoes = [];

  // Usuário logado simulado
  static String? usuarioLogado = "user1";

  // ---------- UTIL ----------
  String gerarId() => DateTime.now().microsecondsSinceEpoch.toString();

  // ---------- USUÁRIO ----------
  Future<String?> getUsuarioLogado() async => usuarioLogado;

  static Future<String?> getUsuarioLogadoStatic() async => usuarioLogado;

  // ---------- PRATOS ----------
  Future<List<Prato>> listarPratos() async => List.from(_pratos);

  Future<List<Prato>> listarPratosPorRestaurante(String restauranteId) async {
    return _pratos.where((p) => p.restauranteId == restauranteId).toList();
  }

  Future<void> adicionarPrato(Prato p) async => _pratos.add(p);

  Future<void> atualizarPrato(Prato p) async {
    final idx = _pratos.indexWhere((e) => e.id == p.id);
    if (idx >= 0) _pratos[idx] = p;
  }

  Future<void> removerPrato(String id) async {
    _pratos.removeWhere((p) => p.id == id);
  }

  // ---------- RESTAURANTES ----------
  Future<List<Restaurante>> listarRestaurantes() async =>
      List.from(_restaurantes);

  Restaurante? buscarRestaurante(String id) {
    return _restaurantes.firstWhere(
      (r) => r.id == id,
      orElse: () => Restaurante(
        id: '',
        nome: '',
        endereco: '',
        usuarioId: '',
        imageUrl: '',
      ),
    );
  }

  // ---------- AVALIAÇÕES ----------
  Future<void> salvarAvaliacao(Avaliacao a) async {
    _avaliacoes.add(a);
  }

  static double mediaAvaliacoes(String pratoId) {
    final avals = _instance._avaliacoes
        .where((a) => a.pratoId == pratoId)
        .map((a) => a.nota)
        .toList();

    if (avals.isEmpty) return 0.0;

    return avals.reduce((a, b) => a + b) / avals.length;
  }

  static bool usuarioPodeAvaliar(String usuarioId, String pratoId) {
    return true;
  }

  // ---------- FAVORITOS ----------
  Future<List<Favorito>> listarFavoritosPorUsuario(String usuarioId) async {
    return _favoritos.where((f) => f.usuarioId == usuarioId).toList();
  }

  Future<void> adicionarFavorito(Favorito f) async => _favoritos.add(f);
}
