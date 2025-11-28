class ExercicioModel {
  final String id;
  final String name;
  final String type;
  final String muscle;
  final String equipment;
  final String difficulty;
  final String instructions;

  ExercicioModel({
    required this.id,
    required this.name,
    required this.type,
    required this.muscle,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
  });

  factory ExercicioModel.fromJson(Map<String, dynamic> json) {
    return ExercicioModel(
      id: '${json['name']}_${json['muscle']}_${json['equipment']}'.replaceAll(' ', '_').toLowerCase(),
      name: json['name'] ?? 'Exercício',
      type: json['type'] ?? 'cardio',
      muscle: json['muscle'] ?? 'unknown',
      equipment: json['equipment']?.toString() ?? 'body_only',
      difficulty: json['difficulty'] ?? 'beginner',
      instructions: json['instructions'] ?? 'Sem instruções disponíveis',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'muscle': muscle,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
    };
  }

  @override
  String toString() {
    return 'ExercicioModel(id: $id, name: $name, muscle: $muscle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExercicioModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
