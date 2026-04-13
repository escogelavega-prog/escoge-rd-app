import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/peticiones/data/models/peticion_model.dart';

class PeticionesService {
  PeticionesService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _peticionesCollection = 'peticiones';
  static const String _usuariosCollection = 'usuarios';

  Stream<List<PeticionModel>> getPeticionesPublicadas() {
    return _firestore
        .collection(_peticionesCollection)
        .where('status', isEqualTo: 'publicada')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PeticionModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> crearPeticion({
    required String userId,
    required String userName,
    required String texto,
    required String categoria,
    required String tipoVisibilidad,
    required bool isAnonymous,
  }) async {
    final peticionRef = _firestore.collection(_peticionesCollection).doc();
    final userRef = _firestore.collection(_usuariosCollection).doc(userId);

    final batch = _firestore.batch();

    batch.set(peticionRef, {
      'userId': userId,
      'userName': userName.trim(),
      'texto': texto.trim(),
      'categoria': categoria.trim(),
      'tipoVisibilidad': tipoVisibilidad,
      'isAnonymous': isAnonymous,
      'status': 'publicada',
      'unidosCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.set(
      userRef,
      {
        'oracionesCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<void> unirseAOracion({
    required String peticionId,
    required String userId,
  }) async {
    final peticionRef =
        _firestore.collection(_peticionesCollection).doc(peticionId);
    final unidoRef = peticionRef.collection('unidos').doc(userId);

    final batch = _firestore.batch();

    batch.set(unidoRef, {
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(peticionRef, {
      'unidosCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<bool> yaSeUnio({
    required String peticionId,
    required String userId,
  }) async {
    final doc = await _firestore
        .collection(_peticionesCollection)
        .doc(peticionId)
        .collection('unidos')
        .doc(userId)
        .get();

    return doc.exists;
  }

  Future<void> repararConteoOracionesUsuario(String userId) async {
    final query = await _firestore
        .collection(_peticionesCollection)
        .where('userId', isEqualTo: userId)
        .get();

    final total = query.docs.length;

    await _firestore.collection(_usuariosCollection).doc(userId).set(
      {
        'oracionesCount': total,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
