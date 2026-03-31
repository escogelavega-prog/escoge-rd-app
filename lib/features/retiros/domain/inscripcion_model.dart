class InscripcionModel {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;
  final String tipoFormulario;
  final String nombre;
  final String apellidos;
  final String cedula;
  final String telefono;
  final String email;
  final String direccion;

  const InscripcionModel({
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
    required this.tipoFormulario,
    required this.nombre,
    required this.apellidos,
    required this.cedula,
    required this.telefono,
    required this.email,
    required this.direccion,
  });

  Map<String, dynamic> toJson() => {
        'diocesis': diocesis,
        'retiroId': retiroId,
        'retiroNombre': retiroNombre,
        'tipoFormulario': tipoFormulario,
        'nombre': nombre,
        'apellidos': apellidos,
        'cedula': cedula,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
      };
}
