class RetiroItemModel {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RetiroItemModel({
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
    required this.destacado,
    required this.activo,
    required this.tipoFormulario,
    this.createdAt,
    this.updatedAt,
  });

  factory RetiroItemModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return RetiroItemModel(
      id: id,
      categoria: (map['categoria'] ?? '').toString(),
      titulo: (map['titulo'] ?? '').toString(),
      ciudad: (map['ciudad'] ?? '').toString(),
      fecha: (map['fecha'] ?? '').toString(),
      diocesis: (map['diocesis'] ?? '').toString(),
      imagePath: (map['imagePath'] ?? '').toString(),
      descripcion: (map['descripcion'] ?? '').toString(),
      lugar: (map['lugar'] ?? '').toString(),
      recomendaciones: (map['recomendaciones'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      destacado: map['destacado'] == true,
      activo: map['activo'] != false,
      tipoFormulario: (map['tipoFormulario'] ?? 'simple').toString(),
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  RetiroItemModel copyWith({
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RetiroItemModel(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
