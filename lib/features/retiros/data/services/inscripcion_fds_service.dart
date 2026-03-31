import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';

class InscripcionFDSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔵 FDS (formulario largo)
  Future<void> guardarInscripcion(InscripcionFdsModel inscripcion) async {
    await _firestore.collection('inscripciones_fds').add({
      'diocesisId': inscripcion.diocesisId,
      'diocesisNombre': inscripcion.diocesisNombre,
      'tipoFormulario': inscripcion.tipoFormulario,
      'tipoEvento': inscripcion.tipoEvento,
      'numeroFinDeSemana': inscripcion.numeroFinDeSemana,
      'fechaEvento': inscripcion.fechaEvento,
      'datosGenerales': inscripcion.datosGenerales,
      'invitador': inscripcion.invitador,
      'familiares': inscripcion.familiares,
      'experienciaEspiritual': inscripcion.experienciaEspiritual,
      'estado': 'pendiente',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🟢 SIMPLE (formulario corto)
  Future<void> guardarInscripcionSimple(InscripcionModel model) async {
    await _firestore.collection('inscripciones').add({
      ...model.toJson(),
      'estado': 'pendiente',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
