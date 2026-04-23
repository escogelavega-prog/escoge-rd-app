import 'package:cloud_firestore/cloud_firestore.dart';

class EvangelioModel {
  // =========================
  // IDENTIDAD
  // =========================
  final String id;

  // =========================
  // CONTENIDO
  // =========================
  final String titulo;
  final String cita;
  final String texto;
  final String? comentario;

  // =========================
  // MULTIMEDIA
  // =========================
  final String? imagenUrl; // URL pública (CDN)
  final String? imagenStorage; // path en Firebase Storage

  final String? audioUrl; // streaming directo
  final String? audioStorage; // path storage

  // =========================
  // METADATA
  // =========================
  final DateTime? fecha;
  final bool published;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // =========================
  // CONSTRUCTOR
  // =========================
  const EvangelioModel({
    required this.id,
    required this.titulo,
    required this.cita,
    required this.texto,
    this.comentario,
    this.imagenUrl,
    this.imagenStorage,
    this.audioUrl,
    this.audioStorage,
    this.fecha,
    this.published = true,
    this.createdAt,
    this.updatedAt,
  });

  // =========================
  // FROM FIRESTORE
  // =========================
  factory EvangelioModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data() ?? {};

    return EvangelioModel(
      id: doc.id,
      titulo: (map['titulo'] ?? '').toString(),
      cita: (map['cita'] ?? '').toString(),
      texto: (map['texto'] ?? '').toString(),
      comentario: map['comentario']?.toString(),
      imagenUrl: map['imagenUrl']?.toString(),
      imagenStorage: map['imagenStorage']?.toString(),
      audioUrl: map['audioUrl']?.toString(),
      audioStorage: map['audioStorage']?.toString(),
      fecha: _parseDate(map['fecha']),
      published: map['published'] ?? true,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  // =========================
  // FROM MAP (fallback/local)
  // =========================
  factory EvangelioModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return EvangelioModel(
      id: id,
      titulo: (map['titulo'] ?? '').toString(),
      cita: (map['cita'] ?? '').toString(),
      texto: (map['texto'] ?? '').toString(),
      comentario: map['comentario']?.toString(),
      imagenUrl: map['imagenUrl']?.toString(),
      imagenStorage: map['imagenStorage']?.toString(),
      audioUrl: map['audioUrl']?.toString(),
      audioStorage: map['audioStorage']?.toString(),
      fecha: _parseDate(map['fecha']),
      published: map['published'] ?? true,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  // =========================
  // TO MAP (Firestore)
  // =========================
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'cita': cita,
      'texto': texto,
      'comentario': comentario,
      'imagenUrl': imagenUrl,
      'imagenStorage': imagenStorage,
      'audioUrl': audioUrl,
      'audioStorage': audioStorage,
      'fecha': fecha != null ? Timestamp.fromDate(fecha!) : null,
      'published': published,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // =========================
  // COPY WITH
  // =========================
  EvangelioModel copyWith({
    String? id,
    String? titulo,
    String? cita,
    String? texto,
    String? comentario,
    String? imagenUrl,
    String? imagenStorage,
    String? audioUrl,
    String? audioStorage,
    DateTime? fecha,
    bool? published,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EvangelioModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      cita: cita ?? this.cita,
      texto: texto ?? this.texto,
      comentario: comentario ?? this.comentario,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      imagenStorage: imagenStorage ?? this.imagenStorage,
      audioUrl: audioUrl ?? this.audioUrl,
      audioStorage: audioStorage ?? this.audioStorage,
      fecha: fecha ?? this.fecha,
      published: published ?? this.published,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // =========================
  // HELPERS
  // =========================
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
