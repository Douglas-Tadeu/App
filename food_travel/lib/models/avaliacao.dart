class Avaliacao {
  final String id;
  final String usuarioId;
  final String pratoId;
  final double nota;
  final String comentario;
  final DateTime? data;

  Avaliacao({required this.id, required this.usuarioId, required this.pratoId, required this.nota, required this.comentario, this.data});

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    double parseNota(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    DateTime? parseData(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return Avaliacao(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
      pratoId: json['pratoId']?.toString() ?? '',
      nota: parseNota(json['nota']),
      comentario: json['comentario'] ?? '',
      data: parseData(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'usuarioId': usuarioId, 'pratoId': pratoId, 'nota': nota, 'comentario': comentario, 'data': data?.toIso8601String()};
}
