class Prato {
  final String id;
  final String nome;
  final String descricao;
  final String imagemUrl;
  final double preco;
  final String restauranteId;
  final String usuarioId;

  Prato({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagemUrl,
    required this.preco,
    required this.restauranteId,
    required this.usuarioId,
  });

  factory Prato.fromJson(Map<String, dynamic> json) {
    double parsePreco(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString().replaceAll(',', '.')) ?? 0.0;
    }
    return Prato(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      imagemUrl: json['imagemUrl'] ?? json['imageUrl'] ?? '',
      preco: parsePreco(json['preco'] ?? json['price']),
      restauranteId: json['restauranteId']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'imagemUrl': imagemUrl,
        'preco': preco,
        'restauranteId': restauranteId,
        'usuarioId': usuarioId,
      };
}
