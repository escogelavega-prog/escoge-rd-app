import 'package:cloud_firestore/cloud_firestore.dart';

class InscripcionRetiroService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> inscribir({
    required String retiroId,
    required Map<String, dynamic> data,
  }) async {
    final retiroRef = _firestore.collection('retiros').doc(retiroId);
    final inscripcionesRef = _firestore.collection('inscripciones');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(retiroRef);

      if (!snapshot.exists) {
        throw Exception('El retiro no existe.');
      }

      final retiro = snapshot.data() as Map<String, dynamic>;

      final int cuposDisponibles =
          (retiro['cuposDisponibles'] as num?)?.toInt() ??
              (retiro['cupos'] as num?)?.toInt() ??
              0;

      final String estado = (retiro['estado'] ?? 'publicado').toString();
      final bool activo = retiro['activo'] != false;

      if (!activo || estado == 'inactivo' || estado == 'oculto') {
        throw Exception('Este retiro no está disponible.');
      }

      if (estado == 'completo' || cuposDisponibles <= 0) {
        throw Exception('Este retiro ya está completo.');
      }

      final newDoc = inscripcionesRef.doc();

      transaction.set(newDoc, {
        ...data,
        'retiroId': retiroId,
        'estado': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final int nuevosCupos = cuposDisponibles - 1;

      transaction.update(retiroRef, {
        'cuposDisponibles': nuevosCupos,
        'estado': nuevosCupos <= 0 ? 'completo' : estado,
      });
    });
  }
}
