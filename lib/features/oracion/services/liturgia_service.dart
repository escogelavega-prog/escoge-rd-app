import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/constants/firebase_collections.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/repositories/liturgia_repository.dart';

class LiturgiaService implements LiturgiaRepository {
  LiturgiaService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Cache simple en memoria por docId (yyyy-MM-dd).
  final Map<String, LiturgiaDayModel?> _memoryCache = {};

  CollectionReference<Map<String, dynamic>> get _liturgiaRef =>
      _firestore.collection(FirebaseCollections.liturgiaDiaria);

  @override
  Future<LiturgiaDayModel?> getTodayLiturgia() async {
    return getLiturgiaByDate(DateTime.now());
  }

  @override
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date) async {
    final docId = _buildDocId(date);

    if (_memoryCache.containsKey(docId)) {
      return _memoryCache[docId];
    }

    return _fetchAndCacheByDocId(docId);
  }

  @override
  Future<LiturgiaDayModel?> getTomorrowLiturgia() async {
    final tomorrow = _dateOnly(DateTime.now()).add(const Duration(days: 1));
    return getLiturgiaByDate(tomorrow);
  }

  @override
  Future<LiturgiaDayModel?> getYesterdayLiturgia() async {
    final yesterday = _dateOnly(DateTime.now()).subtract(
      const Duration(days: 1),
    );
    return getLiturgiaByDate(yesterday);
  }

  @override
  Future<void> preloadTodayAndTomorrow() async {
    final today = _dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    await Future.wait([
      _preloadDate(today),
      _preloadDate(tomorrow),
    ]);
  }

  Future<void> preloadDates(List<DateTime> dates) async {
    await Future.wait(
      dates.map((date) => _preloadDate(_dateOnly(date))),
    );
  }

  Future<void> _preloadDate(DateTime date) async {
    final docId = _buildDocId(date);

    if (_memoryCache.containsKey(docId)) {
      return;
    }

    try {
      await _fetchAndCacheByDocId(docId);
    } catch (_) {
      // La precarga no debe romper la experiencia del usuario.
    }
  }

  @override
  LiturgiaDayModel? getCachedLiturgiaByDate(DateTime date) {
    final docId = _buildDocId(date);
    return _memoryCache[docId];
  }

  @override
  Future<LiturgiaDayModel?> refreshLiturgiaByDate(DateTime date) async {
    final docId = _buildDocId(date);
    _memoryCache.remove(docId);
    return _fetchAndCacheByDocId(docId);
  }

  @override
  void clearCacheForDate(DateTime date) {
    final docId = _buildDocId(date);
    _memoryCache.remove(docId);
  }

  @override
  void clearAllCache() {
    _memoryCache.clear();
  }

  @override
  Stream<LiturgiaDayModel?> watchLiturgiaByDate(DateTime date) {
    final docId = _buildDocId(date);

    return _liturgiaRef.doc(docId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        _memoryCache[docId] = null;
        return null;
      }

      final data = doc.data()!;
      final liturgia = LiturgiaDayModel.fromMap(doc.id, data);

      _memoryCache[docId] = liturgia;
      return liturgia;
    });
  }

  Future<LiturgiaDayModel?> _fetchAndCacheByDocId(String docId) async {
    try {
      final doc = await _liturgiaRef.doc(docId).get();

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
