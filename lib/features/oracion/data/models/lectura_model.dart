class LecturaModel {
  final String tipo;
  final String titulo;
  final String cita;
  final String texto;
  final String? respuesta;

  const LecturaModel({
    required this.tipo,
    required this.titulo,
    required this.cita,
    required this.texto,
    this.respuesta,
  });

  factory LecturaModel.fromMap(Map<String, dynamic> map) {
    return LecturaModel(
      tipo: (map['tipo'] ?? '').toString(),
      titulo: (map['titulo'] ?? '').toString(),
      cita: (map['cita'] ?? '').toString(),
      texto: (map['texto'] ?? '').toString(),
      respuesta: map['respuesta']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'titulo': titulo,
      'cita': cita,
      'texto': texto,
      'respuesta': respuesta,
    };
  }

  LecturaModel copyWith({
    String? tipo,
    String? titulo,
    String? cita,
    String? texto,
    String? respuesta,
  }) {
    return LecturaModel(
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      cita: cita ?? this.cita,
      texto: texto ?? this.texto,
      respuesta: respuesta ?? this.respuesta,
    );
  }
}
