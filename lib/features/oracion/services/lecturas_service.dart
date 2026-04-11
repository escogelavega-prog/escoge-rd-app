import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';

class LecturasService {
  LecturasService({
    LiturgiaService? liturgiaService,
  }) : _liturgiaService = liturgiaService ?? LiturgiaService();

  final LiturgiaService _liturgiaService;

  Future<List<LecturaModel>> getLecturasDelDia() async {
    final liturgia = await _liturgiaService.getTodayLiturgia();
    return liturgia?.lecturas ?? [];
  }

  Future<List<LecturaModel>> getLecturasByDate(DateTime date) async {
    final liturgia = await _liturgiaService.getLiturgiaByDate(date);
    return liturgia?.lecturas ?? [];
  }
}
