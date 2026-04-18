class CatecismoProgressModel {
  final int currentIndex;
  final int currentNumero;
  final String currentTitulo;
  final DateTime? updatedAt;

  const CatecismoProgressModel({
    required this.currentIndex,
    required this.currentNumero,
    required this.currentTitulo,
    this.updatedAt,
  });

  factory CatecismoProgressModel.fromMap(Map<String, dynamic> map) {
    return CatecismoProgressModel(
      currentIndex: (map['currentIndex'] ?? 0) as int,
      currentNumero: (map['currentNumero'] ?? 1) as int,
      currentTitulo: (map['currentTitulo'] ?? '') as String,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentIndex': currentIndex,
      'currentNumero': currentNumero,
      'currentTitulo': currentTitulo,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
