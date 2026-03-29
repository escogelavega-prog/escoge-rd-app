import 'package:cloud_firestore/cloud_firestore.dart';

class InscripcionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarInscripcion({
    required Map<String, dynamic> datos,
    required String tipoFormulario,
    required String retiroId,
    required String retiroNombre,
    required String diocesis,
  }) async {
    await _firestore.collection('inscripciones').add({
      'tipoFormulario': tipoFormulario,
      'retiroId': retiroId,
      'retiroNombre': retiroNombre,
      'diocesis': diocesis,
      'estado': 'pendiente',
      'createdAt': FieldValue.serverTimestamp(),
      'datos': datos,
    });
  }
}
