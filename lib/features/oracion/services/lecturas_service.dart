class LecturasDayData {
  final String fecha;
  final String tiempoLiturgico;
  final String descripcionLiturgica;

  final String primeraLecturaCita;
  final String primeraLecturaContenido;

  final String salmoCita;
  final String salmoContenido;

  final String? segundaLecturaCita;
  final String? segundaLecturaContenido;

  final String evangelioCita;
  final String evangelioIntroduccion;
  final String evangelioContenido;
  final String evangelioDestacado;

  LecturasDayData({
    required this.fecha,
    required this.tiempoLiturgico,
    required this.descripcionLiturgica,
    required this.primeraLecturaCita,
    required this.primeraLecturaContenido,
    required this.salmoCita,
    required this.salmoContenido,
    this.segundaLecturaCita,
    this.segundaLecturaContenido,
    required this.evangelioCita,
    required this.evangelioIntroduccion,
    required this.evangelioContenido,
    required this.evangelioDestacado,
  });

  bool get hasSegundaLectura {
    return (segundaLecturaCita ?? '').trim().isNotEmpty &&
        (segundaLecturaContenido ?? '').trim().isNotEmpty;
  }
}

class LecturasService {
  static Future<LecturasDayData> getLecturasDelDia() async {
    await Future.delayed(const Duration(milliseconds: 350));

    return LecturasDayData(
      fecha: 'Miércoles, 25 de marzo de 2026',
      tiempoLiturgico: 'Tiempo de Cuaresma',
      descripcionLiturgica:
          'La Iglesia nos invita hoy a escuchar la Palabra con recogimiento, apertura del corazón y deseo sincero de conversión.',

      primeraLecturaCita: 'Isaías 49, 8-15',
      primeraLecturaContenido:
          'Esto dice el Señor: “En el tiempo favorable te escuché, en el día de la salvación te auxilié. '
          'Yo te formé y te he destinado para que seas alianza del pueblo, para restaurar la tierra, '
          'para repartir las heredades devastadas, para decir a los cautivos: Salgan; y a los que están en tinieblas: Vengan a la luz”.',

      salmoCita: 'Salmo 144',
      salmoContenido:
          'El Señor es compasivo y misericordioso, lento a la ira y rico en clemencia. '
          'El Señor es bueno con todos, es cariñoso con todas sus criaturas.',

      segundaLecturaCita: '',
      segundaLecturaContenido: '',

      evangelioCita: 'Juan 5, 17-30',
      evangelioIntroduccion: 'Del santo Evangelio según san Juan',
      evangelioContenido:
          'En aquel tiempo, Jesús dijo a los judíos: “Mi Padre sigue actuando y yo también actúo”. '
          'Por eso los judíos tenían más ganas de matarlo, porque no solo quebrantaba el sábado, '
          'sino también llamaba a Dios su propio Padre, haciéndose igual a Dios. '
          'Jesús tomó la palabra y les dijo: “Les aseguro: el Hijo no puede hacer nada por su cuenta, '
          'sino lo que ve hacer al Padre; lo que hace este, también lo hace el Hijo”.',

      evangelioDestacado:
          '“El que escucha mi palabra y cree en el que me envió, tiene vida eterna.”',
    );
  }
}
