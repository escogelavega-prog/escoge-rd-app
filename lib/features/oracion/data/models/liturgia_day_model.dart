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

  const LiturgiaDayModel({
    required this.id,
    required this.fecha,
    required this.titulo,
    required this.tiempoLiturgico,
    required this.colorLiturgico,
    required this.celebracion,
    this.reflexionBreve,
    required this.evangelio,
    required this.lecturas,
    this.santoDelDia,
    this.versiculoDelDia,
    required this.publicado,
  });

  factory LiturgiaDayModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final evangelioMap = map['evangelio'];
    final lecturasList = map['lecturas'] as List<dynamic>? ?? [];
    final santoMap = map['santoDelDia'];
    final versiculoMap = map['versiculoDelDia'];

    return LiturgiaDayModel(
      id: id,
      fecha:
          DateTime.tryParse((map['fecha'] ?? '').toString()) ?? DateTime.now(),
      titulo: (map['titulo'] ?? '').toString(),
      tiempoLiturgico: (map['tiempoLiturgico'] ?? '').toString(),
      colorLiturgico: (map['colorLiturgico'] ?? '').toString(),
      celebracion: (map['celebracion'] ?? '').toString(),
      reflexionBreve: map['reflexionBreve']?.toString(),
      evangelio: evangelioMap is Map<String, dynamic>
          ? EvangelioModel.fromMap(evangelioMap)
          : null,
      lecturas: lecturasList
          .whereType<Map<String, dynamic>>()
          .map(LecturaModel.fromMap)
          .toList(),
      santoDelDia: santoMap is Map<String, dynamic>
          ? SantoModel.fromMap(santoMap)
          : null,
      versiculoDelDia: versiculoMap is Map<String, dynamic>
          ? VersiculoDelDiaModel.fromMap(versiculoMap)
          : null,
      publicado: map['publicado'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fecha': _dateOnlyString(fecha),
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
    );
  }

  static String _dateOnlyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
