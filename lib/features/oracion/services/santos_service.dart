import 'package:escoge/features/oracion/data/models/santo_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';

class SantosService {
  SantosService({
    LiturgiaService? liturgiaService,
  }) : _liturgiaService = liturgiaService ?? LiturgiaService();

  final LiturgiaService _liturgiaService;

  Future<SantoModel?> getSantoDelDia() async {
    final liturgia = await _liturgiaService.getTodayLiturgia();
    return liturgia?.santoDelDia;
  }

  Future<SantoModel?> getSantoByDate(DateTime date) async {
    final liturgia = await _liturgiaService.getLiturgiaByDate(date);
    return liturgia?.santoDelDia;
  }
}
