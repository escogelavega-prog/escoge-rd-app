import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';

class EvangelioService {
  EvangelioService({
    LiturgiaService? liturgiaService,
  }) : _liturgiaService = liturgiaService ?? LiturgiaService();

  final LiturgiaService _liturgiaService;

  Future<EvangelioModel?> getEvangelioDelDia() async {
    final liturgia = await _liturgiaService.getTodayLiturgia();
    return liturgia?.evangelio;
  }

  Future<EvangelioModel?> getEvangelioByDate(DateTime date) async {
    final liturgia = await _liturgiaService.getLiturgiaByDate(date);
    return liturgia?.evangelio;
  }
}
