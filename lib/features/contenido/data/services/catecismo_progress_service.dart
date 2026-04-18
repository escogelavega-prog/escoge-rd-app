import 'package:escoge/features/contenido/data/models/%20catecismo_progress_model.dart';

class CatecismoProgressService {
  static CatecismoProgressModel? _memoryProgress;

  Future<void> saveProgress({
    required int currentIndex,
    required int currentNumero,
    required String currentTitulo,
  }) async {
    _memoryProgress = CatecismoProgressModel(
      currentIndex: currentIndex,
      currentNumero: currentNumero,
      currentTitulo: currentTitulo,
      updatedAt: DateTime.now(),
    );
  }

  Future<CatecismoProgressModel?> getProgress() async {
    return _memoryProgress;
  }

  Stream<CatecismoProgressModel?> watchProgress() async* {
    yield _memoryProgress;
  }
}
