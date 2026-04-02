import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';

class InscripcionFDSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarInscripcion(InscripcionFdsModel inscripcion) async {
    try {
      if (inscripcion.diocesisId.trim().isEmpty) {
        throw Exception('La diócesis es obligatoria.');
      }

      final payload = <String, dynamic>{
        'diocesisId': inscripcion.diocesisId.trim(),
        'diocesisNombre': inscripcion.diocesisNombre.trim(),
        'tipoFormulario': inscripcion.tipoFormulario.trim(),
        'tipoEvento': inscripcion.tipoEvento.trim(),
        'numeroFinDeSemana': inscripcion.numeroFinDeSemana,
        'fechaEvento': Timestamp.fromDate(inscripcion.fechaEvento),
        'datosGenerales': _sanitizarMapa(inscripcion.datosGenerales),
        'invitador': _sanitizarMapa(inscripcion.invitador),
        'familiares': _sanitizarMapa(inscripcion.familiares),
        'experienciaEspiritual':
            _sanitizarMapa(inscripcion.experienciaEspiritual),
        'estado': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      };

      debugPrint('=== GUARDANDO INSCRIPCION FDS ===');
      debugPrint(payload.toString());

      await _firestore
          .collection('inscripciones_fds')
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
      final payload = _sanitizarMapa({
        ...model.toJson(),
        'estado': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('=== GUARDANDO INSCRIPCION SIMPLE ===');
      debugPrint(payload.toString());

      await _firestore
          .collection('inscripciones')
          .add(payload)
          .timeout(const Duration(seconds: 15));

      debugPrint('=== INSCRIPCION SIMPLE GUARDADA OK ===');
    } on FirebaseException catch (e) {
      debugPrint('=== FIREBASE ERROR SIMPLE ===');
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
        e.message ?? 'Ocurrió un error de Firebase al guardar la inscripción.',
      );
    } on TimeoutException {
      debugPrint('=== TIMEOUT AL GUARDAR INSCRIPCION SIMPLE ===');
      throw Exception(
        'La operación tardó demasiado. Verifica tu conexión e intenta nuevamente.',
      );
    } catch (e) {
      debugPrint('=== ERROR INESPERADO SIMPLE ===');
      debugPrint(e.toString());
      throw Exception(
        'Ocurrió un error inesperado al guardar la inscripción: $e',
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

      output[key] = value;
    });

    return output;
  }
}
