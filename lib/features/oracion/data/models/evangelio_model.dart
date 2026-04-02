class EvangelioModel {
  final String titulo;
  final String cita;
  final String contenido;
  final String fecha;

  EvangelioModel({
    required this.titulo,
    required this.cita,
    required this.contenido,
    required this.fecha,
  });

  factory EvangelioModel.fromMap(Map<String, dynamic> map) {
    return EvangelioModel(
      titulo: map['titulo'] ?? '',
      cita: map['cita'] ?? '',
      contenido: map['contenido'] ?? '',
      fecha: map['fecha'] ?? '',
    );
  }
}
