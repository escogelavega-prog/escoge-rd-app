import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';

class InscripcionesRepository {
  final InscripcionFDSService service;

  InscripcionesRepository(this.service);

  Future<void> guardarSimple(InscripcionModel model) async {
    await service.guardarInscripcionSimple(model);
  }

  Future<void> guardarFds(InscripcionFdsModel model) async {
    await service.guardarInscripcion(model);
  }
}
