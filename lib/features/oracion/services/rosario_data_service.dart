import '../data/models/rosario_misterio_model.dart';

class RosarioDataService {
  static const List<String> pasosBase = [
    'Padre Nuestro',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Ave María',
    'Gloria',
    'Jaculatoria',
  ];

  // =========================
  // MÉTODO PRINCIPAL
  // =========================
  static List<RosarioMisterioModel> getMisterios(String tipo) {
    switch (tipo) {
      case 'gozosos':
        return _gozosos;
      case 'dolorosos':
        return _dolorosos;
      case 'gloriosos':
        return _gloriosos;
      case 'luminosos':
        return _luminosos;
      default:
        return _gozosos;
    }
  }

  // =========================
  // DATA ORGANIZADA
  // =========================

  static const List<RosarioMisterioModel> _gozosos = [
    RosarioMisterioModel(
      tituloCorto: '1° Gozoso',
      titulo: 'La Anunciación',
      subtitulo: 'El ángel Gabriel visita a la Virgen María',
      imagePath: 'assets/images/rosario/Gozosos/gozoso01.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '2° Gozoso',
      titulo: 'La Visitación',
      subtitulo: 'María visita a su prima Isabel',
      imagePath: 'assets/images/rosario/Gozosos/gozoso02.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '3° Gozoso',
      titulo: 'El Nacimiento de Jesús',
      subtitulo: 'El Hijo de Dios nace en Belén',
      imagePath: 'assets/images/rosario/Gozosos/gozoso03.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '4° Gozoso',
      titulo: 'La Presentación',
      subtitulo: 'Jesús es presentado en el templo',
      imagePath: 'assets/images/rosario/Gozosos/gozoso04.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '5° Gozoso',
      titulo: 'El Niño Jesús Perdido y Hallado',
      subtitulo: 'Jesús es hallado en el templo',
      imagePath: 'assets/images/rosario/Gozosos/gozoso05.png',
    ),
  ];

  static const List<RosarioMisterioModel> _dolorosos = [
    RosarioMisterioModel(
      tituloCorto: '1° Doloroso',
      titulo: 'La Oración en el Huerto',
      subtitulo: 'Jesús ora en Getsemaní',
      imagePath: 'assets/images/rosario/Dolorosos/doloroso01.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '2° Doloroso',
      titulo: 'La Flagelación',
      subtitulo: 'Jesús es azotado',
      imagePath: 'assets/images/rosario/Dolorosos/doloroso02.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '3° Doloroso',
      titulo: 'La Coronación de Espinas',
      subtitulo: 'Jesús es coronado con espinas',
      imagePath: 'assets/images/rosario/Dolorosos/doloroso03.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '4° Doloroso',
      titulo: 'Jesús con la Cruz a Cuestas',
      subtitulo: 'Camino al Calvario',
      imagePath: 'assets/images/rosario/Dolorosos/doloroso04.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '5° Doloroso',
      titulo: 'La Crucifixión',
      subtitulo: 'Jesús muere en la cruz',
      imagePath: 'assets/images/rosario/Dolorosos/doloroso05.png',
    ),
  ];

  static const List<RosarioMisterioModel> _gloriosos = [
    RosarioMisterioModel(
      tituloCorto: '1° Glorioso',
      titulo: 'La Resurrección',
      subtitulo: 'Jesús resucita glorioso',
      imagePath: 'assets/images/rosario/Gloriosos/glorioso01.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '2° Glorioso',
      titulo: 'La Ascensión',
      subtitulo: 'Jesús asciende al cielo',
      imagePath: 'assets/images/rosario/Gloriosos/glorioso02.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '3° Glorioso',
      titulo: 'Pentecostés',
      subtitulo: 'El Espíritu Santo desciende',
      imagePath: 'assets/images/rosario/Gloriosos/glorioso03.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '4° Glorioso',
      titulo: 'La Asunción',
      subtitulo: 'María es llevada al cielo',
      imagePath: 'assets/images/rosario/Gloriosos/glorioso04.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '5° Glorioso',
      titulo: 'La Coronación',
      subtitulo: 'María es coronada reina',
      imagePath: 'assets/images/rosario/Gloriosos/glorioso05.png',
    ),
  ];

  static const List<RosarioMisterioModel> _luminosos = [
    RosarioMisterioModel(
      tituloCorto: '1° Luminoso',
      titulo: 'El Bautismo de Jesús',
      subtitulo: 'En el Jordán',
      imagePath: 'assets/images/rosario/Luminosos/luminoso01.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '2° Luminoso',
      titulo: 'Las Bodas de Caná',
      subtitulo: 'Primer milagro',
      imagePath: 'assets/images/rosario/Luminosos/luminoso02.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '3° Luminoso',
      titulo: 'El Reino de Dios',
      subtitulo: 'Llamado a la conversión',
      imagePath: 'assets/images/rosario/Luminosos/luminoso03.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '4° Luminoso',
      titulo: 'La Transfiguración',
      subtitulo: 'Jesús glorioso',
      imagePath: 'assets/images/rosario/Luminosos/luminoso04.png',
    ),
    RosarioMisterioModel(
      tituloCorto: '5° Luminoso',
      titulo: 'La Eucaristía',
      subtitulo: 'Entrega total de Cristo',
      imagePath: 'assets/images/rosario/Luminosos/luminoso05.png',
    ),
  ];

  // =========================
  // ORACIONES
  // =========================

  static String getPrayerText(String paso) {
    switch (paso) {
      case 'Padre Nuestro':
        return 'Padre nuestro, que estás en el cielo...';
      case 'Ave María':
        return 'Dios te salve, María...';
      case 'Gloria':
        return 'Gloria al Padre, al Hijo...';
      case 'Jaculatoria':
        return 'María, Madre de gracia...';
      default:
        return 'Continúa con recogimiento y devoción.';
    }
  }
}
