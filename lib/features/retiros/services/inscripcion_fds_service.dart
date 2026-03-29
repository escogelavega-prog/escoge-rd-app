import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';

class InscripcionFdsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarInscripcion(InscripcionFdsModel inscripcion) async {
    await _firestore.collection('inscripciones').add({
      ...inscripcion.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
