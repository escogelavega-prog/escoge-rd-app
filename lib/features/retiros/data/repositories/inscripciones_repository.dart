import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';

class InscripcionesRepository {
  final InscripcionFDSService service;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InscripcionesRepository(this.service);

  Future<void> guardar(InscripcionModel model) async {
    await service.guardarInscripcion(model);
  }

  Future<void> completarPerfilInvitado({
    required String retiroId,
    required String inscripcionId,
    required Map<String, dynamic> perfilInvitado,
    required Map<String, dynamic> completadoPor,
  }) async {
    await service.completarPerfilInvitado(
      retiroId: retiroId,
      inscripcionId: inscripcionId,
      perfilInvitado: perfilInvitado,
      completadoPor: completadoPor,
    );
  }

  Future<Map<String, dynamic>?> buscarInscripcionPorToken(String token) async {
    final limpio = token.trim();
    if (limpio.isEmpty) return null;

    final query = await _firestore
        .collectionGroup('inscripciones')
        .where('invitadorFlow.tokenAcceso', isEqualTo: limpio)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final doc = query.docs.first;
    final parentRetiroRef = doc.reference.parent.parent;

    if (parentRetiroRef == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(doc.data());
    final invitadorFlow =
        Map<String, dynamic>.from(data['invitadorFlow'] ?? {});

    final bloqueado = invitadorFlow['bloqueado'] == true;
    final completado = invitadorFlow['completado'] == true;
    final intentosRestantes = (invitadorFlow['intentosRestantes'] ?? 0) as int;

    final expiraTimestamp = invitadorFlow['tokenExpiraEn'];
    DateTime? expiraEn;
    if (expiraTimestamp is Timestamp) {
      expiraEn = expiraTimestamp.toDate();
    }

    final expirado = expiraEn != null && DateTime.now().isAfter(expiraEn);

    if (bloqueado || completado || expirado || intentosRestantes <= 0) {
      return {
        'inscripcionId': doc.id,
        'retiroId': parentRetiroRef.id,
        'data': data,
        'invalido': true,
        'motivo': bloqueado
            ? 'bloqueado'
            : completado
                ? 'completado'
                : expirado
                    ? 'expirado'
                    : 'sin_intentos',
      };
    }

    return {
      'inscripcionId': doc.id,
      'retiroId': parentRetiroRef.id,
      'data': data,
      'invalido': false,
    };
  }

  Future<void> consumirIntentoFallido({
    required String retiroId,
    required String inscripcionId,
    required int intentosActuales,
  }) async {
    final nuevosIntentos = intentosActuales > 0 ? intentosActuales - 1 : 0;

    await _firestore
        .collection('retiros')
        .doc(retiroId)
        .collection('inscripciones')
        .doc(inscripcionId)
        .update({
      'invitadorFlow.intentosRestantes': nuevosIntentos,
      'invitadorFlow.ultimoIntentoAt': FieldValue.serverTimestamp(),
      'invitadorFlow.bloqueado': nuevosIntentos <= 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
