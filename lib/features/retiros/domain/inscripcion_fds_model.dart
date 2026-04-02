class InscripcionFdsModel {
  final String retiroId;
  final String retiroTitulo;

  final String diocesisId;
  final String diocesisNombre;
  final String tipoFormulario;
  final String tipoEvento;
  final int numeroFinDeSemana;
  final DateTime fechaEvento;

  final Map<String, dynamic> datosGenerales;
  final Map<String, dynamic> invitador;
  final Map<String, dynamic> familiares;
  final Map<String, dynamic> experienciaEspiritual;

  const InscripcionFdsModel({
    required this.retiroId,
    required this.retiroTitulo,
    required this.diocesisId,
    required this.diocesisNombre,
    required this.tipoFormulario,
    required this.tipoEvento,
    required this.numeroFinDeSemana,
    required this.fechaEvento,
    required this.datosGenerales,
    required this.invitador,
    required this.familiares,
    required this.experienciaEspiritual,
  });

  Map<String, dynamic> toMap() {
    return {
      'retiroId': retiroId,
      'retiroTitulo': retiroTitulo,

      'diocesisId': diocesisId,
      'diocesisNombre': diocesisNombre,
      'tipoFormulario': tipoFormulario,
      'tipoEvento': tipoEvento,
      'numeroFinDeSemana': numeroFinDeSemana,
      'fechaEvento': fechaEvento,

      // 🔥 base común
      'estado': 'pendiente',
      'estadoPago': null,
      'origen': 'app',
      'activo': true,
      'createdAt': DateTime.now(),

      // 🔥 bloques del formulario FDS
      'datosGenerales': datosGenerales,
      'invitador': invitador,
      'familiares': familiares,
      'experienciaEspiritual': experienciaEspiritual,
    };
  }
}
