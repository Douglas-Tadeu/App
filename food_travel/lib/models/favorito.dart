class Favorito {
  final String id;
  final String usuarioId;
  final String pratoId;
  final DateTime? data;

  Favorito({required this.id, required this.usuarioId, required this.pratoId, this.data});

  factory Favorito.fromJson(Map<String, dynamic> json) {
    DateTime? parseData(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }
    return Favorito(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? '',
      pratoId: json['pratoId']?.toString() ?? '',
      data: parseData(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'usuarioId': usuarioId, 'pratoId': pratoId, 'data': data?.toIso8601String()};
}
