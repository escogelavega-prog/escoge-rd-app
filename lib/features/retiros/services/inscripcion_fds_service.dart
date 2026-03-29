import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';

class InscripcionFDSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
