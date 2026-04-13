import 'package:escoge/features/peticiones/data/models/peticion_model.dart';

abstract class PeticionesRepository {
  Future<void> crearPeticion({
    required String userId,
    required String userName,
    required String texto,
    required String categoria,
    required String tipoVisibilidad, // publica | anonima
  });

  Stream<List<PeticionModel>> getPeticionesPublicadas();

  Future<void> unirseAOracion({
    required String peticionId,
    required String userId,
  });

  Future<bool> yaSeUnio({
    required String peticionId,
    required String userId,
  });
}
