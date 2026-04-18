class MultimediaItemModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String tipo;
  final String categoria;

  final String storagePath;
  final String downloadUrl;
  final String thumbnailUrl;

  final int duracionSegundos;
  final bool activo;
  final bool publicado;
  final int orden;

  final DateTime? fechaPublicacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MultimediaItemModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.categoria,
    required this.storagePath,
    required this.downloadUrl,
    required this.thumbnailUrl,
    required this.duracionSegundos,
    required this.activo,
    required this.publicado,
    required this.orden,
    this.fechaPublicacion,
    this.createdAt,
    this.updatedAt,
  });

  factory MultimediaItemModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return MultimediaItemModel(
      id: id,
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      tipo: map['tipo'] ?? '',
      categoria: map['categoria'] ?? '',
      storagePath: map['storagePath'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      duracionSegundos: (map['duracionSegundos'] ?? 0) as int,
      activo: map['activo'] ?? false,
      publicado: map['publicado'] ?? false,
      orden: (map['orden'] ?? 0) as int,
      fechaPublicacion: _parseDate(map['fechaPublicacion']),
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'categoria': categoria,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'thumbnailUrl': thumbnailUrl,
      'duracionSegundos': duracionSegundos,
      'activo': activo,
      'publicado': publicado,
      'orden': orden,
      'fechaPublicacion': fechaPublicacion?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  MultimediaItemModel copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? tipo,
    String? categoria,
    String? storagePath,
    String? downloadUrl,
    String? thumbnailUrl,
    int? duracionSegundos,
    bool? activo,
    bool? publicado,
    int? orden,
    DateTime? fechaPublicacion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MultimediaItemModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
      storagePath: storagePath ?? this.storagePath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      activo: activo ?? this.activo,
      publicado: publicado ?? this.publicado,
      orden: orden ?? this.orden,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value.toString().isEmpty) return null;

    return DateTime.tryParse(value.toString());
  }
}