import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/peticiones/data/models/peticion_model.dart';

import 'package:escoge/features/peticiones/repositories/peticiones_repository.dart';

class PeticionesService implements PeticionesRepository {
  PeticionesService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'peticiones';

  @override
  Future<void> crearPeticion({
    required String userId,
    required String userName,
    required String texto,
    required String categoria,
    required String tipoVisibilidad,
  }) async {
    final isAnonymous = tipoVisibilidad == 'anonima';

    await _firestore.collection(_collection).add({
      'userId': userId,
      'userName': userName,
      'texto': texto.trim(),
      'categoria': categoria,
      'tipoVisibilidad': tipoVisibilidad,
      'isAnonymous': isAnonymous,
      'status': 'publicada',
      'unidosCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<PeticionModel>> getPeticionesPublicadas() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      final peticiones = snapshot.docs
          .map(
            (doc) => PeticionModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .where((peticion) => peticion.status == 'publicada')
          .toList();

      peticiones.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return peticiones;
    });
  }

  @override
  Future<void> unirseAOracion({
    required String peticionId,
    required String userId,
  }) async {
    final peticionRef = _firestore.collection(_collection).doc(peticionId);
    final unionRef = peticionRef.collection('unidos').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final unionSnapshot = await transaction.get(unionRef);

      if (unionSnapshot.exists) {
        return;
      }

      transaction.set(unionRef, {
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(peticionRef, {
        'unidosCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<bool> yaSeUnio({
    required String peticionId,
    required String userId,
  }) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(peticionId)
        .collection('unidos')
        .doc(userId)
        .get();

    return doc.exists;
  }
}
