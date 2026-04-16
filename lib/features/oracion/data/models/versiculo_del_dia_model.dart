class VersiculoDelDiaModel {
  final String texto;
  final String cita;

  const VersiculoDelDiaModel({
    required this.texto,
    required this.cita,
  });

  factory VersiculoDelDiaModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return VersiculoDelDiaModel(
      texto: (map['texto'] ?? '').toString(),
      cita: (map['cita'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'cita': cita,
    };
  }

  VersiculoDelDiaModel copyWith({
    String? texto,
    String? cita,
  }) {
    return VersiculoDelDiaModel(
      texto: texto ?? this.texto,
      cita: cita ?? this.cita,
    );
  }
}
