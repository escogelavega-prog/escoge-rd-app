class EvangelioModel {
  final String titulo;
  final String cita;
  final String texto;
  final String? comentario;
  final String? imagenUrl;

  const EvangelioModel({
    required this.titulo,
    required this.cita,
    required this.texto,
    this.comentario,
    this.imagenUrl,
  });

  factory EvangelioModel.fromMap(Map<String, dynamic> map) {
    return EvangelioModel(
      titulo: (map['titulo'] ?? '').toString(),
      cita: (map['cita'] ?? '').toString(),
      texto: (map['texto'] ?? '').toString(),
      comentario: map['comentario']?.toString(),
      imagenUrl: map['imagenUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'cita': cita,
      'texto': texto,
      'comentario': comentario,
      'imagenUrl': imagenUrl,
    };
  }

  EvangelioModel copyWith({
    String? titulo,
    String? cita,
    String? texto,
    String? comentario,
    String? imagenUrl,
  }) {
    return EvangelioModel(
      titulo: titulo ?? this.titulo,
      cita: cita ?? this.cita,
      texto: texto ?? this.texto,
      comentario: comentario ?? this.comentario,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }
}
