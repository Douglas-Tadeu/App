// lib/services/food_travel_service.dart
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import '../models/usuario.dart';
import '../models/restaurante.dart';
import '../models/prato.dart';
import '../models/avaliacao.dart';
import '../models/favorito.dart';
import '../models/login_dto.dart';

class FoodTravelService {
  final List<Usuario> _usuarios = [];
  final List<Restaurante> _restaurantes = [];
  final List<Prato> _pratos = [];
  final List<Avaliacao> _avaliacoes = [];
  final List<Favorito> _favoritos = [];

  final _uuid = const Uuid();

  // ------------------ USUÁRIO ------------------
  void adicionarUsuario(Usuario usuario) {
    _usuarios.add(usuario);
  }

  List<Usuario> listarUsuarios() => List.unmodifiable(_usuarios);

  Usuario? getUsuarioPorId(String id) =>
      _usuarios.firstWhereOrNull((u) => u.id == id);

  Usuario? autenticar(LoginDTO loginDTO) {
    return _usuarios.firstWhereOrNull(
      (u) => u.email == loginDTO.email && u.senha == loginDTO.senha,
    );
  }

  void atualizarUsuario(Usuario usuario) {
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) _usuarios[index] = usuario;
  }

  void removerUsuario(String id) {
    _usuarios.removeWhere((u) => u.id == id);
  }

  // ------------------ RESTAURANTE ------------------
  void adicionarRestaurante(Restaurante r) => _restaurantes.add(r);

  List<Restaurante> listarRestaurantes() => List.unmodifiable(_restaurantes);

  Restaurante? getRestaurantePorId(String id) =>
      _restaurantes.firstWhereOrNull((r) => r.id == id);

  void atualizarRestaurante(Restaurante r) {
    final index = _restaurantes.indexWhere((rest) => rest.id == r.id);
    if (index != -1) _restaurantes[index] = r;
  }

  void removerRestaurante(String id) {
    _restaurantes.removeWhere((r) => r.id == id);
    // opcional: remover pratos/avaliacoes vinculadas
    _pratos.removeWhere((p) => p.restauranteId == id);
    _avaliacoes.removeWhere((a) {
      final prato = getPratoPorId(a.pratoId);
      return prato == null || prato.restauranteId == id;
    });
  }

  // ------------------ PRATO ------------------
  void adicionarPrato(Prato p) => _pratos.add(p);

  List<Prato> listarPratos() => List.unmodifiable(_pratos);

  List<Prato> listarPratosPorRestaurante(String restauranteId) =>
      _pratos.where((p) => p.restauranteId == restauranteId).toList();

  Prato? getPratoPorId(String id) => _pratos.firstWhereOrNull((p) => p.id == id);

  void atualizarPrato(Prato p) {
    final index = _pratos.indexWhere((pr) => pr.id == p.id);
    if (index != -1) _pratos[index] = p;
  }

  void removerPrato(String id) {
    _pratos.removeWhere((p) => p.id == id);
    _avaliacoes.removeWhere((a) => a.pratoId == id); // limpa avaliacoes do prato
  }

  // ------------------ AVALIAÇÃO ------------------
  void adicionarAvaliacao(Avaliacao a) => _avaliacoes.add(a);

  List<Avaliacao> listarAvaliacoesPorPrato(String pratoId) =>
      _avaliacoes.where((a) => a.pratoId == pratoId).toList();

  List<Avaliacao> listarAvaliacoes() => List.unmodifiable(_avaliacoes);

  double calcularMediaAvaliacoes(String pratoId) {
    final avaliacoes = listarAvaliacoesPorPrato(pratoId);
    if (avaliacoes.isEmpty) return 0.0;
    final total = avaliacoes.fold<double>(0, (sum, a) => sum + a.nota);
    return total / avaliacoes.length;
  }

  // ------------------ FAVORITOS ------------------
  void adicionarFavorito(Favorito f) {
    if (!_favoritos.any(
        (fav) => fav.usuarioId == f.usuarioId && fav.pratoId == f.pratoId)) {
      _favoritos.add(f);
    }
  }

  void removerFavorito(String usuarioId, String pratoId) {
    _favoritos.removeWhere(
        (f) => f.usuarioId == usuarioId && f.pratoId == pratoId);
  }

  List<Prato> listarFavoritosDoUsuario(String usuarioId) {
    final idsFavoritos =
        _favoritos.where((f) => f.usuarioId == usuarioId).map((f) => f.pratoId);
    return _pratos.where((p) => idsFavoritos.contains(p.id)).toList();
  }

  // ------------------ NOVAS FUNÇÕES DE PERMISSÃO E AJUDA ------------------

  /// Retorna true se [usuarioId] for dono do restaurante [restauranteId].
  bool usuarioEhDonoDoRestaurante(String restauranteId, String usuarioId) {
    final rest = getRestaurantePorId(restauranteId);
    if (rest == null) return false;
    return rest.usuarioId == usuarioId;
  }

  /// Retorna true se [usuarioId] pode avaliar o prato [pratoId].
  /// Regra: o dono do restaurante NÃO pode avaliar seus próprios pratos.
  /// Também impede avaliações duplicadas do mesmo usuário no mesmo prato.
  bool usuarioPodeAvaliar(String usuarioId, String pratoId) {
    final prato = getPratoPorId(pratoId);
    if (prato == null) return false;
    final rest = getRestaurantePorId(prato.restauranteId);
    if (rest == null) return false;
    if (rest.usuarioId == usuarioId) return false; // dono não pode
    // verificar se já avaliou
    return !hasUserAvaliado(pratoId, usuarioId);
  }

  /// True se o usuário já avaliou esse prato.
  bool hasUserAvaliado(String pratoId, String usuarioId) {
    return _avaliacoes.any((a) => a.pratoId == pratoId && a.usuarioId == usuarioId);
  }

  /// Conveniência: cria uma avaliação nova com id automático.
  /// Retorna true se avalição criada com sucesso (ou false caso regra impeça).
  bool criarAvaliacao(String pratoId, String usuarioId, double nota, String comentario) {
    if (!usuarioPodeAvaliar(usuarioId, pratoId)) return false;
    final nova = Avaliacao(
      id: _uuid.v4(),
      pratoId: pratoId,
      usuarioId: usuarioId,
      nota: nota,
      comentario: comentario,
    );
    adicionarAvaliacao(nova);
    return true;
  }

  /// Retorna todos os pratos (útil para debug/relatórios).
  List<Prato> listarPratosCompletos() => List.unmodifiable(_pratos);
}
