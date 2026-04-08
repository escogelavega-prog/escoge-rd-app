import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:escoge/features/retiros/domain/inscripcion_model.dart';

class InscripcionFDSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarInscripcion(InscripcionModel inscripcion) async {
    try {
      if (inscripcion.retiroId.trim().isEmpty) {
        throw Exception('El retiro es obligatorio.');
      }

      if (inscripcion.retiroDiocesisId.trim().isEmpty) {
        throw Exception('La diócesis del retiro es obligatoria.');
      }

      final payload = _sanitizarMapa(inscripcion.toJson());

      payload['createdAt'] = FieldValue.serverTimestamp();
      payload['updatedAt'] = FieldValue.serverTimestamp();
      payload['submittedAt'] = FieldValue.serverTimestamp();

      debugPrint('=== GUARDANDO INSCRIPCION FDS ===');
      debugPrint('retiroId: ${inscripcion.retiroId}');
      debugPrint(payload.toString());

      await _firestore
          .collection('retiros')
          .doc(inscripcion.retiroId)
          .collection('inscripciones')
          .add(payload)
          .timeout(const Duration(seconds: 15));

      debugPrint('=== INSCRIPCION FDS GUARDADA OK ===');
    } on FirebaseException catch (e) {
      debugPrint('=== FIREBASE ERROR FDS ===');
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');

      if (e.code == 'permission-denied') {
        throw Exception(
          'Firestore rechazó la escritura. Revisa las reglas de seguridad.',
        );
      }

      if (e.code == 'unavailable') {
        throw Exception(
          'Firestore no está disponible en este momento. Intenta de nuevo.',
        );
      }

      throw Exception(
        e.message ??
            'Ocurrió un error de Firebase al guardar la inscripción FDS.',
      );
    } on TimeoutException {
      debugPrint('=== TIMEOUT AL GUARDAR INSCRIPCION FDS ===');
      throw Exception(
        'La operación tardó demasiado. Verifica tu conexión e intenta nuevamente.',
      );
    } catch (e) {
      debugPrint('=== ERROR INESPERADO FDS ===');
      debugPrint(e.toString());
      throw Exception(
        'Ocurrió un error inesperado al guardar la inscripción FDS: $e',
      );
    }
  }

  Future<void> guardarInscripcionSimple(InscripcionModel model) async {
    try {
      if (model.retiroId.trim().isEmpty) {
        throw Exception('El retiro es obligatorio.');
      }

      if (model.retiroDiocesisId.trim().isEmpty) {
        throw Exception('La diócesis del retiro es obligatoria.');
      }

      final payload = _sanitizarMapa(model.toJson());

      payload['createdAt'] = FieldValue.serverTimestamp();
      payload['updatedAt'] = FieldValue.serverTimestamp();
      payload['submittedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('retiros')
          .doc(model.retiroId)
          .collection('inscripciones')
          .add(payload)
          .timeout(const Duration(seconds: 15));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception(
          'Firestore rechazó la escritura. Revisa las reglas de seguridad.',
        );
      }

      if (e.code == 'unavailable') {
        throw Exception(
          'Firestore no está disponible en este momento. Intenta de nuevo.',
        );
      }

      throw Exception(
        e.message ?? 'Ocurrió un error de Firebase al guardar la inscripción.',
      );
    } on TimeoutException {
      throw Exception(
        'La operación tardó demasiado. Verifica tu conexión e intenta nuevamente.',
      );
    } catch (e) {
      throw Exception(
        'Ocurrió un error inesperado al guardar la inscripción: $e',
      );
    }
  }

  Future<void> completarPerfilInvitado({
    required String retiroId,
    required String inscripcionId,
    required Map<String, dynamic> perfilInvitado,
    required Map<String, dynamic> completadoPor,
  }) async {
    try {
      if (retiroId.trim().isEmpty) {
        throw Exception('El retiro es obligatorio.');
      }

      if (inscripcionId.trim().isEmpty) {
        throw Exception('La inscripción es obligatoria.');
      }

      final perfilSanitizado = _sanitizarMapa(perfilInvitado);
      final completadoPorSanitizado = _sanitizarMapa(completadoPor);

      await _firestore
          .collection('retiros')
          .doc(retiroId)
          .collection('inscripciones')
          .doc(inscripcionId)
          .update({
        // 🔹 guardar formulario
        'perfilInvitado': perfilSanitizado,

        // 🔹 flujo
        'invitadorFlow.estado': 'completado',
        'invitadorFlow.completado': true,
        'invitadorFlow.bloqueado': true,
        'invitadorFlow.fechaCompletado': FieldValue.serverTimestamp(),

        // 🔹 QUIÉN LO COMPLETÓ
        'invitadorFlow.completadoPor': completadoPorSanitizado,

        // 🔹 control
        'formulariosCompletados.perfilInvitado': true,

        // 🔹 timestamp
        'updatedAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 15));

      debugPrint('=== PERFIL INVITADO COMPLETADO OK ===');
    } on FirebaseException catch (e) {
      debugPrint('=== FIREBASE ERROR PERFIL INVITADO ===');
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');

      if (e.code == 'permission-denied') {
        throw Exception(
          'Firestore rechazó la actualización. Revisa las reglas de seguridad.',
        );
      }

      if (e.code == 'not-found') {
        throw Exception('No se encontró la inscripción a actualizar.');
      }

      if (e.code == 'unavailable') {
        throw Exception(
          'Firestore no está disponible en este momento. Intenta de nuevo.',
        );
      }

      throw Exception(
        e.message ??
            'Ocurrió un error de Firebase al actualizar el perfil del invitado.',
      );
    } on TimeoutException {
      debugPrint('=== TIMEOUT AL ACTUALIZAR PERFIL INVITADO ===');
      throw Exception(
        'La operación tardó demasiado. Verifica tu conexión e intenta nuevamente.',
      );
    } catch (e) {
      debugPrint('=== ERROR INESPERADO PERFIL INVITADO ===');
      debugPrint(e.toString());
      throw Exception(
        'Ocurrió un error inesperado al actualizar el perfil del invitado: $e',
      );
    }
  }

  Map<String, dynamic> _sanitizarMapa(Map<String, dynamic> input) {
    final output = <String, dynamic>{};

    input.forEach((key, value) {
      if (value == null) return;

      if (value is String) {
        output[key] = value.trim();
        return;
      }

      if (value is DateTime) {
        output[key] = Timestamp.fromDate(value);
        return;
      }

      if (value is Map<String, dynamic>) {
        output[key] = _sanitizarMapa(value);
        return;
      }

      if (value is List) {
        output[key] = value.map((item) {
          if (item is String) return item.trim();
          if (item is DateTime) return Timestamp.fromDate(item);
          if (item is Map<String, dynamic>) return _sanitizarMapa(item);
          return item;
        }).toList();
        return;
      }

      output[key] = value;
    });

    return output;
  }
}
