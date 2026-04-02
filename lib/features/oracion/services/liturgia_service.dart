import 'package:cloud_firestore/cloud_firestore.dart';

class LiturgiaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String buildDateId(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _buildAltDateId(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day-$month-$year';
  }

  Future<Map<String, dynamic>?> obtenerLiturgiaDelDia([DateTime? date]) async {
    final targetDate = date ?? DateTime.now();

    try {
      final direct = await _buscarDocumentoLiturgia(targetDate);
      if (direct != null) {
        return _normalizarLiturgia(direct);
      }

      final ultima = await _obtenerUltimoDocumentoDisponible();
      if (ultima != null) {
        return _normalizarLiturgia(ultima);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> obtenerLiturgiaPorFecha(DateTime date) async {
    try {
      final data = await _buscarDocumentoLiturgia(date);
      return data == null ? null : _normalizarLiturgia(data);
    } catch (_) {
      return null;
    }
  }

  Stream<Map<String, dynamic>?> escucharLiturgiaDelDia([DateTime? date]) async* {
    final targetDate = date ?? DateTime.now();
    yield await obtenerLiturgiaDelDia(targetDate);
  }

  Future<bool> existeLiturgiaParaFecha(DateTime date) async {
    final data = await _buscarDocumentoLiturgia(date);
    return data != null;
  }

  Future<List<Map<String, dynamic>>> obtenerUltimasLiturgias({int limite = 7}) async {
    try {
      final snapshot = await _firestore
          .collection('liturgia_diaria')
          .limit(limite)
          .get();

      return snapshot.docs
          .map((e) => _normalizarLiturgia(e.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> _buscarDocumentoLiturgia(DateTime date) async {
    final candidates = <Future<Map<String, dynamic>?>>[
      _docToData('liturgia_diaria', buildDateId(date)),
      _docToData('liturgia_diaria', _buildAltDateId(date)),
      _docToData('liturgia_diaria', 'hoy'),
      _docToData('liturgia', buildDateId(date)),
      _docToData('liturgia', 'hoy'),
      _queryByFecha('liturgia_diaria', date),
      _queryByFecha('liturgia', date),
      _armarDesdeColeccionesSeparadas(date),
    ];

    for (final future in candidates) {
      final result = await future;
      if (result != null && result.isNotEmpty) return result;
    }

    return null;
  }

  Future<Map<String, dynamic>?> _obtenerUltimoDocumentoDisponible() async {
    for (final collection in ['liturgia_diaria', 'liturgia']) {
      try {
        final snapshot = await _firestore.collection(collection).limit(10).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data();
        }
      } catch (_) {}
    }
    return null;
  }

  Future<Map<String, dynamic>?> _docToData(String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (!doc.exists || doc.data() == null) return null;
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _queryByFecha(String collection, DateTime date) async {
    final iso = buildDateId(date);
    final alt = _buildAltDateId(date);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final attempts = <Future<QuerySnapshot<Map<String, dynamic>>>>[
      _firestore.collection(collection).where('fecha', isEqualTo: iso).limit(1).get(),
      _firestore.collection(collection).where('fecha', isEqualTo: alt).limit(1).get(),
      _firestore.collection(collection).where('fechaId', isEqualTo: iso).limit(1).get(),
      _firestore.collection(collection).where('fechaTexto', isEqualTo: iso).limit(1).get(),
      _firestore.collection(collection).where('fechaDate', isEqualTo: Timestamp.fromDate(dateOnly)).limit(1).get(),
    ];

    for (final attempt in attempts) {
      try {
        final snap = await attempt;
        if (snap.docs.isNotEmpty) return snap.docs.first.data();
      } catch (_) {}
    }
    return null;
  }

  Future<Map<String, dynamic>?> _armarDesdeColeccionesSeparadas(DateTime date) async {
    try {
      final iso = buildDateId(date);

      final evangelio = await _docToData('evangelio', iso) ?? await _docToData('evangelio', 'hoy');
      final lecturas = await _docToData('lecturas_diarias', iso) ??
          await _docToData('lecturas_diarias', 'hoy') ??
          await _docToData('lecturas', iso) ??
          await _docToData('lecturas', 'hoy');
      final santo = await _docToData('santo_del_dia', iso) ?? await _docToData('santo_del_dia', 'hoy');
      final reflexion = await _docToData('reflexion_diaria', iso) ??
          await _docToData('reflexion_diaria', 'hoy');

      if (evangelio == null && lecturas == null && santo == null && reflexion == null) {
        return null;
      }

      return {
        ...?lecturas,
        if (evangelio != null) 'evangelio': evangelio,
        if (santo != null) 'santoDelDia': santo,
        if (reflexion != null) 'reflexion': reflexion,
      };
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _normalizarLiturgia(Map<String, dynamic> raw) {
    final primeraLectura = _extraerSeccion(raw, [
      'primeraLectura',
      'lectura1',
      'primera_lectura',
    ]);

    final salmo = _extraerSeccion(raw, ['salmo', 'salmoResponsorial']);
    final segundaLectura = _extraerSeccion(raw, ['segundaLectura', 'lectura2', 'segunda_lectura']);
    final evangelio = _extraerSeccion(raw, ['evangelio']);
    final reflexion = _extraerSeccion(raw, ['reflexion', 'meditacion']);
    final santoDelDia = _extraerSeccion(raw, ['santoDelDia', 'santo', 'santo_del_dia']);

    return {
      'tituloDia': _leerString(raw, ['tituloDia', 'titulo', 'nombreDia'], fallback: 'Hoy en la Iglesia'),
      'celebracion': _leerString(raw, ['celebracion', 'descripcionLiturgica', 'descripcion']),
      'tiempoLiturgico': _leerString(raw, ['tiempoLiturgico', 'tiempo', 'temporada']),
      'colorLiturgico': _leerString(raw, ['colorLiturgico', 'color']),
      'fecha': _leerString(raw, ['fecha', 'fechaTexto', 'fechaId']),
      'primeraLectura': _normalizarBloque(
        primeraLectura,
        tituloFallback: 'Primera lectura',
      ),
      'salmo': _normalizarBloque(
        salmo,
        tituloFallback: 'Salmo responsorial',
        respuestaKeys: ['respuesta', 'antifona'],
      ),
      'segundaLectura': _normalizarBloque(
        segundaLectura,
        tituloFallback: 'Segunda lectura',
      ),
      'evangelio': _normalizarBloque(
        evangelio,
        tituloFallback: 'Evangelio del día',
      ),
      'reflexion': {
        'titulo': _leerString(reflexion, ['titulo', 'nombre'], fallback: 'Reflexión del día'),
        'texto': _leerString(reflexion, ['texto', 'contenido', 'descripcion']),
        'autor': _leerString(reflexion, ['autor']),
      },
      'santoDelDia': {
        'nombre': _leerString(santoDelDia, ['nombre', 'titulo'], fallback: 'Santo del día'),
        'descripcionBreve': _leerString(santoDelDia, ['descripcionBreve', 'descripcion', 'texto']),
        'frase': _leerString(santoDelDia, ['frase', 'cita']),
      },
    };
  }

  Map<String, dynamic>? _extraerSeccion(Map<String, dynamic>? source, List<String> keys) {
    if (source == null) return null;
    for (final key in keys) {
      final value = source[key];
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
    }

    final hasFlatFields = keys.any((key) => source.keys.any((k) => k.toLowerCase().contains(key.toLowerCase())));
    return hasFlatFields ? source : null;
  }

  Map<String, dynamic> _normalizarBloque(
    Map<String, dynamic>? data, {
    required String tituloFallback,
    List<String> respuestaKeys = const [],
  }) {
    return {
      'titulo': _leerString(data, ['titulo', 'nombre'], fallback: tituloFallback),
      'cita': _leerString(data, ['cita', 'referencia', 'versiculo']),
      'texto': _leerString(data, ['texto', 'contenido', 'descripcion', 'lectura']),
      'respuesta': _leerString(data, respuestaKeys),
    };
  }

  String _leerString(Map<String, dynamic>? source, List<String> keys, {String fallback = ''}) {
    if (source == null) return fallback;

    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }

    return fallback;
  }
}
