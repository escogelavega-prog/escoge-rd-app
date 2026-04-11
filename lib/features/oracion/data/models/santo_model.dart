class SantoModel {
  final String nombre;
  final String subtitulo;
  final String resumen;
  final String? historia;
  final String? frase;
  final String? imagenUrl;
  final bool destacado;

  const SantoModel({
    required this.nombre,
    required this.subtitulo,
    required this.resumen,
    this.historia,
    this.frase,
    this.imagenUrl,
    this.destacado = false,
  });

  factory SantoModel.fromMap(Map<String, dynamic> map) {
    return SantoModel(
      nombre: (map['nombre'] ?? '').toString(),
      subtitulo: (map['subtitulo'] ?? '').toString(),
      resumen: (map['resumen'] ?? '').toString(),
      historia: map['historia']?.toString(),
      frase: map['frase']?.toString(),
      imagenUrl: map['imagenUrl']?.toString(),
      destacado: map['destacado'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'subtitulo': subtitulo,
      'resumen': resumen,
      'historia': historia,
      'frase': frase,
      'imagenUrl': imagenUrl,
      'destacado': destacado,
    };
  }

  SantoModel copyWith({
    String? nombre,
    String? subtitulo,
    String? resumen,
    String? historia,
    String? frase,
    String? imagenUrl,
    bool? destacado,
  }) {
    return SantoModel(
      nombre: nombre ?? this.nombre,
      subtitulo: subtitulo ?? this.subtitulo,
      resumen: resumen ?? this.resumen,
      historia: historia ?? this.historia,
      frase: frase ?? this.frase,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      destacado: destacado ?? this.destacado,
    );
  }
}
