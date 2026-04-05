import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class LecturasDayData {
  final String fecha;
  final String titulo;
  final String? subtitulo;
  final String? celebracion;
  final String? tiempoLiturgico;
  final String? colorLiturgico;
  final String? tipoCelebracion;
  final String? fraseClave;
  final String? preguntaDelDia;
  final String? accionDelDia;

  final Map<String, dynamic>? primeraLectura;
  final Map<String, dynamic>? salmo;
  final Map<String, dynamic>? segundaLectura;
  final Map<String, dynamic>? evangelio;
  final Map<String, dynamic>? reflexion;
  final Map<String, dynamic>? oracionFinal;
  final Map<String, dynamic>? santoDelDia;

  const LecturasDayData({
    required this.fecha,
    required this.titulo,
    this.subtitulo,
    this.celebracion,
    this.tiempoLiturgico,
    this.colorLiturgico,
    this.tipoCelebracion,
    this.fraseClave,
    this.preguntaDelDia,
    this.accionDelDia,
    this.primeraLectura,
    this.salmo,
    this.segundaLectura,
    this.evangelio,
    this.reflexion,
    this.oracionFinal,
    this.santoDelDia,
  });

  factory LecturasDayData.fromMap(Map<String, dynamic> map) {
    return LecturasDayData(
      fecha: (map['fecha'] ?? '').toString(),
      titulo: (map['titulo'] ?? 'Lecturas del día').toString(),
      subtitulo: _asString(map['subtitulo']),
      celebracion: _asString(map['celebracion']),
      tiempoLiturgico: _asString(map['tiempo_liturgico']),
      colorLiturgico: _asString(map['color_liturgico']),
      tipoCelebracion: _asString(map['tipo_celebracion']),
      fraseClave: _asString(map['frase_clave']),
      preguntaDelDia: _asString(map['pregunta_del_dia']),
      accionDelDia: _asString(map['accion_del_dia']),
      primeraLectura: _asMap(map['primera_lectura']),
      salmo: _asMap(map['salmo']),
      segundaLectura: _asMap(map['segunda_lectura']),
      evangelio: _asMap(map['evangelio']),
      reflexion: _asMap(map['reflexion']),
      oracionFinal: _asMap(map['oracion_final']),
    );
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
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

  bool get hasContent {
    return _hasMapContent(primeraLectura) ||
        _hasMapContent(salmo) ||
        _hasMapContent(segundaLectura) ||
        _hasMapContent(evangelio) ||
        _hasMapContent(reflexion) ||
        _hasMapContent(oracionFinal);
  }

  static bool _hasMapContent(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return false;

    for (final value in map.values) {
      if (value != null && value.toString().trim().isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}

class LecturasService {
  LecturasService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // IMPORTANTE: tu colección real
  static const String _collection = 'liturgia_diaria';

  static Future<LecturasDayData?> getLecturasDelDia() async {
    final todayId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return getLecturasPorFecha(todayId);
  }

  static Future<LecturasDayData?> getLecturasPorFecha(String fechaId) async {
    try {
      debugPrint('📘 LecturasService: buscando en $_collection/$fechaId');

      final doc = await _firestore.collection(_collection).doc(fechaId).get();

      debugPrint('📘 LecturasService: doc.exists = ${doc.exists}');

      if (!doc.exists) {
        return null;
      }

      final data = doc.data();
      debugPrint('📘 LecturasService: data = $data');

      if (data == null) {
        return null;
      }

      final item = LecturasDayData.fromMap(data);
      debugPrint('📘 LecturasService: hasContent = ${item.hasContent}');

      if (!item.hasContent) {
        return null;
      }

      return item;
    } catch (e, st) {
      debugPrint('❌ LecturasService error: $e');
      debugPrint('$st');
      return null;
    }
  }

  static Future<LecturasDayData?> getLecturasDelDiaConFallback() async {
    final todayId = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final exact = await getLecturasPorFecha(todayId);
    if (exact != null) return exact;

    try {
      final query = await _firestore
          .collection(_collection)
          .where('publicado', isEqualTo: true)
          .limit(10)
          .get();

      if (query.docs.isEmpty) return null;

      final docs = query.docs.toList()
        ..sort((a, b) {
          final fechaA = (a.data()['fecha'] ?? '').toString();
          final fechaB = (b.data()['fecha'] ?? '').toString();
          return fechaB.compareTo(fechaA);
        });

      final data = docs.first.data();
      final item = LecturasDayData.fromMap(data);

      if (!item.hasContent) return null;

      return item;
    } catch (e, st) {
      debugPrint('❌ LecturasService fallback error: $e');
      debugPrint('$st');
      return null;
    }
  }
}
