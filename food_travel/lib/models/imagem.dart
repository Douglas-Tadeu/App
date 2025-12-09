class Imagem {
  final String id;
  final String url;
  final String? pratoId;
  final String? restauranteId;

  Imagem({
    required this.id,
    required this.url,
    this.pratoId,
    this.restauranteId,
  });

  factory Imagem.fromJson(Map<String, dynamic> json) {
    return Imagem(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      url: json['url'] ?? json['imageUrl'] ?? json['imagemUrl'] ?? '',
      pratoId: json['pratoId']?.toString(),
      restauranteId: json['restauranteId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'pratoId': pratoId,
      'restauranteId': restauranteId,
    };
  }
}
