// lib/models/restaurante.dart
class Restaurante {
  final String id;
  final String usuarioId; // DONO DO RESTAURANTE
  final String nome;
  final String endereco;
  final String imageUrl;

  Restaurante({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.endereco,
    this.imageUrl = '',
  });
}
