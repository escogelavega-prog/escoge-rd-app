import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';

abstract class LiturgiaRepository {
  // =========================
  // CONSULTAS PRINCIPALES
  // =========================
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date);

  Future<LiturgiaDayModel?> getTodayLiturgia();
  Future<LiturgiaDayModel?> getTomorrowLiturgia();
  Future<LiturgiaDayModel?> getYesterdayLiturgia();

  // =========================
  // REFRESH / SINCRONIZACIÓN
  // =========================
  Future<LiturgiaDayModel?> refreshLiturgiaByDate(DateTime date);

  Stream<LiturgiaDayModel?> watchLiturgiaByDate(DateTime date);

  // =========================
  // CACHE / PRELOAD
  // =========================
  Future<void> preloadTodayAndTomorrow();

  LiturgiaDayModel? getCachedLiturgiaByDate(DateTime date);

  void clearCacheForDate(DateTime date);
  void clearAllCache();
}
