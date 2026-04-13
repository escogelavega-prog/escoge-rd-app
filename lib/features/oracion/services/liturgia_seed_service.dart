import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class LiturgiaSeedResult {
  final int total;
  final int created;
  final int updated;
  final int skipped;
  final List<String> errors;

  const LiturgiaSeedResult({
    required this.total,
    required this.created,
    required this.updated,
    required this.skipped,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
}

class LiturgiaSeedPreviewItem {
  final String fecha;
  final String titulo;
  final String celebracion;
  final bool publicado;
  final int lecturasCount;
  final bool hasEvangelio;
  final bool hasSanto;
  final List<String> warnings;

  const LiturgiaSeedPreviewItem({
    required this.fecha,
    required this.titulo,
    required this.celebracion,
    required this.publicado,
    required this.lecturasCount,
    required this.hasEvangelio,
    required this.hasSanto,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
}

class LiturgiaSeedPreviewResult {
  final int total;
  final List<LiturgiaSeedPreviewItem> items;
  final List<String> globalErrors;

  const LiturgiaSeedPreviewResult({
    required this.total,
    required this.items,
    required this.globalErrors,
  });

  bool get hasErrors => globalErrors.isNotEmpty;
}

class LiturgiaSeedService {
  LiturgiaSeedService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'liturgia_diaria';

  Future<LiturgiaSeedPreviewResult> previewFromAsset({
    required String assetPath,
    DateTime? from,
    DateTime? to,
  }) async {
    final rawJson = await rootBundle.loadString(assetPath);
    return previewFromJsonString(
      rawJson: rawJson,
      from: from,
      to: to,
    );
  }

  Future<LiturgiaSeedPreviewResult> previewFromJsonString({
    required String rawJson,
    DateTime? from,
    DateTime? to,
  }) async {
    final decoded = jsonDecode(rawJson);
    final items = _extractItems(decoded);

    final previewItems = <LiturgiaSeedPreviewItem>[];
    final globalErrors = <String>[];

    for (final item in items) {
      try {
        final fecha = (item['fecha'] ?? '').toString().trim();
        final parsedDate = DateTime.tryParse(fecha);

        if (fecha.isEmpty || parsedDate == null) {
          globalErrors.add('Documento con fecha inválida o vacía.');
          continue;
        }

        if (!_isInRange(parsedDate, from: from, to: to)) {
          continue;
        }

        final evangelio = item['evangelio'];
        final lecturas = item['lecturas'];
        final santo = item['santoDelDia'];

        final warnings = <String>[];

        if (evangelio is! Map) {
          warnings.add('No incluye evangelio válido.');
        } else {
          final cita = (evangelio['cita'] ?? '').toString().trim();
          final texto = (evangelio['texto'] ?? '').toString().trim();
          if (cita.isEmpty) warnings.add('El evangelio no tiene cita.');
          if (texto.isEmpty) warnings.add('El evangelio no tiene texto.');
        }

        int lecturasCount = 0;
        if (lecturas is List) {
          lecturasCount = lecturas.length;
          if (lecturas.isEmpty) {
            warnings.add('No incluye lecturas.');
          }
        } else {
          warnings.add('El campo lecturas no tiene formato válido.');
        }

        final celebracion = (item['celebracion'] ?? '').toString().trim();
        if (celebracion.isEmpty) {
          warnings.add('No incluye celebración.');
        }

        previewItems.add(
          LiturgiaSeedPreviewItem(
            fecha: fecha,
            titulo: (item['titulo'] ?? 'Evangelio del día').toString().trim(),
            celebracion: celebracion,
            publicado: item['publicado'] == true,
            lecturasCount: lecturasCount,
            hasEvangelio: evangelio is Map,
            hasSanto: santo is Map,
            warnings: warnings,
          ),
        );
      } catch (e) {
        globalErrors.add('Error analizando documento: $e');
      }
    }

    return LiturgiaSeedPreviewResult(
      total: previewItems.length,
      items: previewItems,
      globalErrors: globalErrors,
    );
  }

  Future<LiturgiaSeedResult> seedFromAsset({
    required String assetPath,
    bool overwrite = false,
    DateTime? from,
    DateTime? to,
  }) async {
    final rawJson = await rootBundle.loadString(assetPath);
    return seedFromJsonString(
      rawJson: rawJson,
      overwrite: overwrite,
      from: from,
      to: to,
    );
  }

  Future<LiturgiaSeedResult> seedFromJsonString({
    required String rawJson,
    bool overwrite = false,
    DateTime? from,
    DateTime? to,
  }) async {
    final decoded = jsonDecode(rawJson);
    final items = _extractItems(decoded);

    int created = 0;
    int updated = 0;
    int skipped = 0;
    final errors = <String>[];

    for (final item in items) {
      try {
        final normalized = _normalizeLiturgiaItem(item);

        final fechaString = (normalized['fecha'] ?? '').toString().trim();
        if (fechaString.isEmpty) {
          errors.add('Documento sin fecha válida.');
          continue;
        }

        final fecha = DateTime.tryParse(fechaString);
        if (fecha == null) {
          errors.add('Fecha inválida: $fechaString');
          continue;
        }

        if (!_isInRange(fecha, from: from, to: to)) {
          skipped++;
          continue;
        }

        final docRef = _firestore.collection(_collection).doc(fechaString);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists && !overwrite) {
          skipped++;
          continue;
        }

        await docRef.set(normalized, SetOptions(merge: false));

        if (docSnapshot.exists) {
          updated++;
        } else {
          created++;
        }
      } catch (e) {
        final fecha = (item['fecha'] ?? 'sin_fecha').toString();
        errors.add('Error procesando $fecha: $e');
      }
    }

    return LiturgiaSeedResult(
      total: items.length,
      created: created,
      updated: updated,
      skipped: skipped,
      errors: errors,
    );
  }

  List<Map<String, dynamic>> _extractItems(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded['items'] is List) {
        return (decoded['items'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      return [decoded];
    }

    throw Exception(
      'Formato JSON no válido. Se esperaba una lista o un objeto con la clave "items".',
    );
  }

  Map<String, dynamic> _normalizeLiturgiaItem(Map<String, dynamic> raw) {
    final fecha = (raw['fecha'] ?? '').toString().trim();
    if (fecha.isEmpty) {
      throw Exception('La liturgia debe incluir "fecha".');
    }

    final evangelio = raw['evangelio'];
    if (evangelio is! Map) {
      throw Exception('La liturgia $fecha debe incluir "evangelio".');
    }

    final lecturas = raw['lecturas'];
    if (lecturas is! List || lecturas.isEmpty) {
      throw Exception('La liturgia $fecha debe incluir al menos una lectura.');
    }

    final normalized = <String, dynamic>{
      'fecha': fecha,
      'titulo': (raw['titulo'] ?? 'Evangelio del día').toString().trim(),
      'celebracion': (raw['celebracion'] ?? '').toString().trim(),
      'colorLiturgico': (raw['colorLiturgico'] ?? '').toString().trim(),
      'tiempoLiturgico': (raw['tiempoLiturgico'] ?? '').toString().trim(),
      'publicado': raw['publicado'] == true,
      'reflexionBreve': raw['reflexionBreve']?.toString().trim(),
      'evangelio': _normalizeEvangelio(Map<String, dynamic>.from(evangelio)),
      'lecturas': (lecturas)
          .whereType<Map>()
          .map((e) => _normalizeLectura(Map<String, dynamic>.from(e)))
          .toList(),
      'santoDelDia': raw['santoDelDia'] is Map
          ? _normalizeSanto(Map<String, dynamic>.from(raw['santoDelDia']))
          : null,
    };

    return _removeNulls(normalized);
  }

  Map<String, dynamic> _normalizeEvangelio(Map<String, dynamic> map) {
    return _removeNulls({
      'titulo': (map['titulo'] ?? '').toString().trim(),
      'cita': (map['cita'] ?? '').toString().trim(),
      'texto': (map['texto'] ?? '').toString().trim(),
    });
  }

  Map<String, dynamic> _normalizeLectura(Map<String, dynamic> map) {
    return _removeNulls({
      'tipo': (map['tipo'] ?? '').toString().trim(),
      'titulo': (map['titulo'] ?? '').toString().trim(),
      'cita': (map['cita'] ?? '').toString().trim(),
      'texto': (map['texto'] ?? '').toString().trim(),
      'respuesta': (map['respuesta'] ?? '').toString(),
    });
  }

  Map<String, dynamic> _normalizeSanto(Map<String, dynamic> map) {
    return _removeNulls({
      'nombre': (map['nombre'] ?? '').toString().trim(),
      'subtitulo': (map['subtitulo'] ?? '').toString().trim(),
      'resumen': (map['resumen'] ?? '').toString().trim(),
      'historia': (map['historia'] ?? '').toString().trim(),
      'frase': (map['frase'] ?? '').toString().trim(),
      'imagenUrl': (map['imagenUrl'] ?? '').toString().trim(),
      'destacado': map['destacado'] == true,
    });
  }

  Map<String, dynamic> _removeNulls(Map<String, dynamic> input) {
    final output = <String, dynamic>{};

    for (final entry in input.entries) {
      final value = entry.value;

      if (value == null) continue;

      if (value is Map<String, dynamic>) {
        output[entry.key] = _removeNulls(value);
        continue;
      }

      if (value is List) {
        output[entry.key] = value.map((e) {
          if (e is Map<String, dynamic>) {
            return _removeNulls(e);
          }
          return e;
        }).toList();
        continue;
      }

      output[entry.key] = value;
    }

    return output;
  }

  bool _isInRange(
    DateTime date, {
    DateTime? from,
    DateTime? to,
  }) {
    final value = DateTime(date.year, date.month, date.day);

    if (from != null) {
      final start = DateTime(from.year, from.month, from.day);
      if (value.isBefore(start)) return false;
    }

    if (to != null) {
      final end = DateTime(to.year, to.month, to.day);
      if (value.isAfter(end)) return false;
    }

    return true;
  }
}
