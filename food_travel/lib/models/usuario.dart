class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;

  Usuario({required this.id, required this.nome, required this.email, required this.senha});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'email': email, 'senha': senha};
}
