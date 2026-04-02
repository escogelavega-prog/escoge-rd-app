class RetiroItem {
  final String id;
  final String categoria;
  final String titulo;
  final String ciudad;
  final String fecha;
  final String diocesis;
  final String imagePath;
  final String descripcion;
  final String lugar;
  final List<String> recomendaciones;

  final bool destacado;
  final bool activo;
  final String tipoFormulario;

  const RetiroItem({
    required this.id,
    required this.categoria,
    required this.titulo,
    required this.ciudad,
    required this.fecha,
    required this.diocesis,
    required this.imagePath,
    required this.descripcion,
    required this.lugar,
    required this.recomendaciones,
    this.destacado = false,
    this.activo = true,
    this.tipoFormulario = 'general',
  });

  factory RetiroItem.fromMap(Map<String, dynamic> map, {String? docId}) {
    return RetiroItem(
      id: docId ?? (map['id'] as String? ?? ''),
      categoria: map['categoria'] as String? ?? '',
      titulo: map['titulo'] as String? ?? '',
      ciudad: map['ciudad'] as String? ?? '',
      fecha: map['fecha'] as String? ?? '',
      diocesis: map['diocesis'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      descripcion: map['descripcion'] as String? ?? '',
      lugar: map['lugar'] as String? ?? '',
      recomendaciones: (map['recomendaciones'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      destacado: map['destacado'] as bool? ?? false,
      activo: map['activo'] as bool? ?? true,
      tipoFormulario: map['tipoFormulario'] as String? ?? 'general',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': categoria,
      'titulo': titulo,
      'ciudad': ciudad,
      'fecha': fecha,
      'diocesis': diocesis,
      'imagePath': imagePath,
      'descripcion': descripcion,
      'lugar': lugar,
      'recomendaciones': recomendaciones,
      'destacado': destacado,
      'activo': activo,
      'tipoFormulario': tipoFormulario,
    };
  }

  RetiroItem copyWith({
    String? id,
    String? categoria,
    String? titulo,
    String? ciudad,
    String? fecha,
    String? diocesis,
    String? imagePath,
    String? descripcion,
    String? lugar,
    List<String>? recomendaciones,
    bool? destacado,
    bool? activo,
    String? tipoFormulario,
  }) {
    return RetiroItem(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      titulo: titulo ?? this.titulo,
      ciudad: ciudad ?? this.ciudad,
      fecha: fecha ?? this.fecha,
      diocesis: diocesis ?? this.diocesis,
      imagePath: imagePath ?? this.imagePath,
      descripcion: descripcion ?? this.descripcion,
      lugar: lugar ?? this.lugar,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      destacado: destacado ?? this.destacado,
      activo: activo ?? this.activo,
      tipoFormulario: tipoFormulario ?? this.tipoFormulario,
    );
  }
}
