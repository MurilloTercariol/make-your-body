class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final List<String> objetivos;

  UsuarioModel({
    required this.id,
    required this.nome,
    this.email = '',
    this.objetivos = const [],
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      objetivos: List<String>.from(json['objetivos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'objetivos': objetivos,
    };
  }
}
