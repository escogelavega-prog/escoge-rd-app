class EvangelioModel {
  final String fecha;
  final String cita;
  final String introduccion;
  final String cuerpo;
  final String destacado;
  final String reflexion;

  EvangelioModel({
    required this.fecha,
    required this.cita,
    required this.introduccion,
    required this.cuerpo,
    required this.destacado,
    required this.reflexion,
  });

  factory EvangelioModel.fromJson(Map<String, dynamic> json) {
    return EvangelioModel(
      fecha: json['fecha'] ?? '',
      cita: json['cita'] ?? '',
      introduccion: json['introduccion'] ?? '',
      cuerpo: json['cuerpo'] ?? '',
      destacado: json['destacado'] ?? '',
      reflexion: json['reflexion'] ?? '',
    );
  }
}
