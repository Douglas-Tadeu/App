class Restaurante {
  final String id;
  final String nome;
  final String endereco;
  final String usuarioId;
  String imageUrl;

  Restaurante({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.usuarioId,
    this.imageUrl = "",
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    return Restaurante(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      endereco: json['endereco'] ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
      imageUrl: json['imageUrl'] ?? json['imagemUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'endereco': endereco,
        'usuarioId': usuarioId,
        'imageUrl': imageUrl,
      };
}
