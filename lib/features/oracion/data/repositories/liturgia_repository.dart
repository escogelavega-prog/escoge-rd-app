import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';

abstract class LiturgiaRepository {
  Future<LiturgiaDayModel?> getTodayLiturgia();
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date);
  Future<LiturgiaDayModel?> getTomorrowLiturgia();
  Future<LiturgiaDayModel?> getYesterdayLiturgia();

  Future<void> preloadTodayAndTomorrow();

  LiturgiaDayModel? getCachedLiturgiaByDate(DateTime date);

  Future<LiturgiaDayModel?> refreshLiturgiaByDate(DateTime date);

  Stream<LiturgiaDayModel?> watchLiturgiaByDate(DateTime date);

  void clearCacheForDate(DateTime date);
  void clearAllCache();
}
