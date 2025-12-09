class LoginDto {
  final String email;
  final String senha;

  LoginDto({
    required this.email,
    required this.senha,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      email: json['email'] ?? '',
      senha: json['senha'] ?? json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}
