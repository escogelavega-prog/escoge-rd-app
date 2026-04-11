import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';

abstract class LiturgiaRepository {
  Future<LiturgiaDayModel?> getTodayLiturgia();
  Future<LiturgiaDayModel?> getLiturgiaByDate(DateTime date);
}
