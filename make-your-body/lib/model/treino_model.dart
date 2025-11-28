class TreinoModel {
  final int id;
  final String name;

  TreinoModel({
    required this.id,
    required this.name,
  });

  factory TreinoModel.fromJson(Map<String, dynamic> json) {
    return TreinoModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
