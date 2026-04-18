import 'package:escoge/features/contenido/data/models/%20catecismo_progress_model.dart';
import 'package:escoge/features/contenido/data/services/catecismo_progress_service.dart';

class CatecismoProgressRepository {
  CatecismoProgressRepository({
    CatecismoProgressService? service,
  }) : _service = service ?? CatecismoProgressService();

  final CatecismoProgressService _service;

  Future<void> saveProgress({
    required int currentIndex,
    required int currentNumero,
    required String currentTitulo,
  }) {
    return _service.saveProgress(
      currentIndex: currentIndex,
      currentNumero: currentNumero,
      currentTitulo: currentTitulo,
    );
  }

  Future<CatecismoProgressModel?> getProgress() {
    return _service.getProgress();
  }

  Stream<CatecismoProgressModel?> watchProgress() {
    return _service.watchProgress();
  }
}
