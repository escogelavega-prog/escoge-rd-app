class RetiroItem {
  final String categoria;
  final String titulo;
  final String ciudad;
  final String fecha;
  final String diocesis;
  final String imagePath;
  final String descripcion;
  final String lugar;
  final List<String> recomendaciones;

  const RetiroItem({
    required this.categoria,
    required this.titulo,
    required this.ciudad,
    required this.fecha,
    required this.diocesis,
    required this.imagePath,
    required this.descripcion,
    required this.lugar,
    required this.recomendaciones,
  });
}
