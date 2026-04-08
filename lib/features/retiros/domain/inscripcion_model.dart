class InscripcionModel {
  final String retiroId;
  final String retiroTitulo;
  final String retiroTipoEvento;
  final int retiroNumeroFinDeSemana;
  final String retiroDiocesisId;
  final String retiroDiocesisNombre;

  final String tipoFormulario;
  final String modalidadIngreso;
  final bool requiereFormularioInvitador;

  final Map<String, dynamic> participante;
  final Map<String, dynamic> familiares;
  final Map<String, dynamic> experienciaEspiritual;
  final Map<String, dynamic> motivacion;
  final Map<String, dynamic> referenciaInvitador;

  final Map<String, dynamic>? perfilInvitado;
  final Map<String, dynamic> invitadorFlow;
  final Map<String, dynamic> formulariosCompletados;
  final Map<String, dynamic> aceptacion;
  final Map<String, dynamic> admin;

  final DateTime? fechaEvento;

  const InscripcionModel({
    required this.retiroId,
    required this.retiroTitulo,
    required this.retiroTipoEvento,
    required this.retiroNumeroFinDeSemana,
    required this.retiroDiocesisId,
    required this.retiroDiocesisNombre,
    required this.tipoFormulario,
    required this.modalidadIngreso,
    required this.requiereFormularioInvitador,
    required this.participante,
    required this.familiares,
    required this.experienciaEspiritual,
    required this.motivacion,
    required this.referenciaInvitador,
    this.perfilInvitado,
    required this.invitadorFlow,
    required this.formulariosCompletados,
    required this.aceptacion,
    required this.admin,
    this.fechaEvento,
  });

  Map<String, dynamic> toJson() {
    return {
      // 🔹 Datos del retiro
      'retiroId': retiroId,
      'retiroTitulo': retiroTitulo,
      'retiroTipoEvento': retiroTipoEvento,
      'retiroNumeroFinDeSemana': retiroNumeroFinDeSemana,
      'retiroDiocesisId': retiroDiocesisId,
      'retiroDiocesisNombre': retiroDiocesisNombre,

      // 🔹 Tipo de formulario
      'tipoFormulario': tipoFormulario,
      'modalidadIngreso': modalidadIngreso,
      'requiereFormularioInvitador': requiereFormularioInvitador,

      // 🔹 Estados base
      'estado': 'pendiente',
      'revisionEstado': 'pendiente',
      'origen': 'app',
      'activo': true,

      // 🔹 Bloques principales
      'participante': participante,
      'familiares': familiares,
      'experienciaEspiritual': experienciaEspiritual,
      'motivacion': motivacion,
      'referenciaInvitador': referenciaInvitador,

      // 🔹 Formulario del invitador (puede ser null)
      'perfilInvitado': perfilInvitado,

      // 🔹 Control del flujo del invitador
      'invitadorFlow': invitadorFlow,

      // 🔹 Control de formularios
      'formulariosCompletados': formulariosCompletados,

      // 🔹 Aceptación del participante
      'aceptacion': aceptacion,

      // 🔹 Administración
      'admin': admin,

      // 🔹 Fecha del evento
      'fechaEvento': fechaEvento,

      // 🔹 Timestamps (temporalmente con DateTime)
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'submittedAt': DateTime.now(),
    };
  }
}
