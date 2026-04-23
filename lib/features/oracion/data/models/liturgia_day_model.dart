import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/data/models/santo_model.dart';
import 'package:escoge/features/oracion/data/models/versiculo_del_dia_model.dart';

class LiturgiaDayModel {
  final String id;
  final DateTime fecha;
  final String titulo;
  final String tiempoLiturgico;
  final String colorLiturgico;
  final String celebracion;
  final String? reflexionBreve;
  final EvangelioModel? evangelio;
  final List<LecturaModel> lecturas;
  final SantoModel? santoDelDia;
  final VersiculoDelDiaModel? versiculoDelDia;
  final bool publicado;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LiturgiaDayModel({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.tiempoLiturgico,
    required this.colorLiturgico,
    required this.celebracion,
    this.reflexionBreve,
    this.evangelio,
    required this.lecturas,
    this.santoDelDia,
    this.versiculoDelDia,
    required this.publicado,
    this.createdAt,
    this.updatedAt,
  });

  factory LiturgiaDayModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final evangelioMap = _asStringDynamicMap(map['evangelio']);
    final santoMap = _asStringDynamicMap(map['santoDelDia']);
    final versiculoMap = _asStringDynamicMap(map['versiculoDelDia']);
    final lecturasList = map['lecturas'] as List<dynamic>? ?? const [];

    return LiturgiaDayModel(
      id: id,
      fecha: _parseDate(map['fecha']) ?? DateTime.now(),
      titulo: (map['titulo'] ?? '').toString(),
      tiempoLiturgico: (map['tiempoLiturgico'] ?? '').toString(),
      colorLiturgico: (map['colorLiturgico'] ?? '').toString(),
      celebracion: (map['celebracion'] ?? '').toString(),
      reflexionBreve: map['reflexionBreve']?.toString(),
      evangelio:
          evangelioMap != null ? EvangelioModel.fromMap(evangelioMap) : null,
      lecturas: lecturasList
          .map(_asStringDynamicMap)
          .whereType<Map<String, dynamic>>()
          .map(LecturaModel.fromMap)
          .toList(),
      santoDelDia: santoMap != null ? SantoModel.fromMap(santoMap) : null,
      versiculoDelDia: versiculoMap != null
          ? VersiculoDelDiaModel.fromMap(versiculoMap)
          : null,
      publicado: map['publicado'] is bool ? map['publicado'] as bool : false,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fecha': Timestamp.fromDate(
        DateTime(fecha.year, fecha.month, fecha.day),
      ),
      'titulo': titulo,
      'tiempoLiturgico': tiempoLiturgico,
      'colorLiturgico': colorLiturgico,
      'celebracion': celebracion,
      'reflexionBreve': reflexionBreve,
      'evangelio': evangelio?.toMap(),
      'lecturas': lecturas.map((e) => e.toMap()).toList(),
      'santoDelDia': santoDelDia?.toMap(),
      'versiculoDelDia': versiculoDelDia?.toMap(),
      'publicado': publicado,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  LiturgiaDayModel copyWith({
    String? id,
    DateTime? fecha,
    String? titulo,
    String? tiempoLiturgico,
    String? colorLiturgico,
    String? celebracion,
    String? reflexionBreve,
    EvangelioModel? evangelio,
    List<LecturaModel>? lecturas,
    SantoModel? santoDelDia,
    VersiculoDelDiaModel? versiculoDelDia,
    bool? publicado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LiturgiaDayModel(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      titulo: titulo ?? this.titulo,
      tiempoLiturgico: tiempoLiturgico ?? this.tiempoLiturgico,
      colorLiturgico: colorLiturgico ?? this.colorLiturgico,
      celebracion: celebracion ?? this.celebracion,
      reflexionBreve: reflexionBreve ?? this.reflexionBreve,
      evangelio: evangelio ?? this.evangelio,
      lecturas: lecturas ?? this.lecturas,
      santoDelDia: santoDelDia ?? this.santoDelDia,
      versiculoDelDia: versiculoDelDia ?? this.versiculoDelDia,
      publicado: publicado ?? this.publicado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }

    return null;
  }

  static String buildDocId(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
