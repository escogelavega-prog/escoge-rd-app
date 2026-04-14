import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/repositories/liturgia_repository.dart';

class LiturgiaService implements LiturgiaRepository {
  LiturgiaService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'liturgia_diaria';

  /// Cache simple en memoria por docId (yyyy-MM-dd).
  final Map<String, LiturgiaDayModel?> _memoryCache = {};

  @override
  Future<LiturgiaDayModel?> getTodayLiturgia() async {
    final now = DateTime.now();
    return getLiturgiaByDate(now);
  }

  @override
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date) async {
    final docId = _buildDocId(date);

    // 1) Si ya existe en cache, devolver de inmediato.
    if (_memoryCache.containsKey(docId)) {
      return _memoryCache[docId];
    }

    // 2) Si no existe, consultar Firestore y guardar en cache.
    return _fetchAndCacheByDocId(docId);
  }

  /// Precarga hoy y mañana para que la navegación se sienta más fluida.
  @override
  Future<void> preloadTodayAndTomorrow() async {
    final today = _dateOnly(DateTime.now());
    final tomorrow = _dateOnly(today.add(const Duration(days: 1)));

    await Future.wait([
      _preloadDate(today),
      _preloadDate(tomorrow),
    ]);
  }

  /// Precarga una fecha puntual si aún no está en cache.
  Future<void> _preloadDate(DateTime date) async {
    final docId = _buildDocId(date);

    if (_memoryCache.containsKey(docId)) {
      return;
    }

    try {
      await _fetchAndCacheByDocId(docId);
    } catch (_) {
      // Silencioso a propósito:
      // la precarga no debe romper la UX si falla.
    }
  }

  /// Devuelve el dato desde memoria si existe; si no, null.
  @override
  LiturgiaDayModel? getCachedLiturgiaByDate(DateTime date) {
    final docId = _buildDocId(date);
    return _memoryCache[docId];
  }

  /// Permite invalidar una fecha específica.
  @override
  void clearCacheForDate(DateTime date) {
    final docId = _buildDocId(date);
    _memoryCache.remove(docId);
  }

  /// Limpia todo el cache.
  @override
  void clearAllCache() {
    _memoryCache.clear();
  }

  Future<LiturgiaDayModel?> _fetchAndCacheByDocId(String docId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(docId).get();

      if (!doc.exists || doc.data() == null) {
        _memoryCache[docId] = null;
        return null;
      }

      final data = doc.data()!;
      final liturgia = LiturgiaDayModel.fromMap(doc.id, data);

      _memoryCache[docId] = liturgia;
      return liturgia;
    } catch (e) {
      throw Exception('Error al obtener la liturgia del día ($docId): $e');
    }
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _buildDocId(DateTime date) {
    final normalized = _dateOnly(date);

    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
