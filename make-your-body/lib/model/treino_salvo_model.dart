import 'exercicio_model.dart';

class TreinoSalvoModel {
  final String id;
  final String nome;
  final List<ExercicioModel> exercicios;
  final DateTime dataCriacao;
  final DateTime? ultimaExecucao;

  TreinoSalvoModel({
    required this.id,
    required this.nome,
    required this.exercicios,
    required this.dataCriacao,
    this.ultimaExecucao,
  });

  factory TreinoSalvoModel.fromJson(Map<String, dynamic> json) {
    return TreinoSalvoModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Treino',
      exercicios:
          (json['exercicios'] as List?)
              ?.map((e) => ExercicioModel.fromJson(e))
              .toList() ??
          [],
      dataCriacao:
          DateTime.tryParse(json['dataCriacao'] ?? '') ?? DateTime.now(),
      ultimaExecucao: json['ultimaExecucao'] != null
          ? DateTime.tryParse(json['ultimaExecucao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'exercicios': exercicios.map((e) => e.toJson()).toList(),
      'dataCriacao': dataCriacao.toIso8601String(),
      'ultimaExecucao': ultimaExecucao?.toIso8601String(),
    };
  }

  TreinoSalvoModel copyWith({
    String? id,
    String? nome,
    List<ExercicioModel>? exercicios,
    DateTime? dataCriacao,
    DateTime? ultimaExecucao,
  }) {
    return TreinoSalvoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      exercicios: exercicios ?? this.exercicios,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      ultimaExecucao: ultimaExecucao ?? this.ultimaExecucao,
    );
  }

  @override
  String toString() {
    return 'TreinoSalvoModel(id: $id, nome: $nome, exercicios: ${exercicios.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreinoSalvoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
