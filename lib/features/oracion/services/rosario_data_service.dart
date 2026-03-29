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

  static List<RosarioMisterioModel> getMisterios(String tipo) {
    switch (tipo) {
      case 'gozosos':
        return const [
          RosarioMisterioModel(
            tituloCorto: 'Primer Misterio Gozoso',
            titulo: 'La Anunciación',
            subtitulo: 'El ángel Gabriel visita a la Virgen María',
            imagePath: 'assets/rosario/backgrounds/rosario_gozoso_1.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Segundo Misterio Gozoso',
            titulo: 'La Visitación',
            subtitulo: 'María visita a su prima Isabel',
            imagePath: 'assets/rosario/backgrounds/rosario_gozoso_2.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Tercer Misterio Gozoso',
            titulo: 'El Nacimiento de Jesús',
            subtitulo: 'El Hijo de Dios nace en Belén',
            imagePath: 'assets/rosario/backgrounds/rosario_gozoso_3.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Cuarto Misterio Gozoso',
            titulo: 'La Presentación',
            subtitulo: 'Jesús es presentado en el templo',
            imagePath: 'assets/rosario/backgrounds/rosario_gozoso_4.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Quinto Misterio Gozoso',
            titulo: 'El Niño Jesús Perdido y Hallado',
            subtitulo: 'Jesús es hallado en el templo',
            imagePath: 'assets/rosario/backgrounds/rosario_gozoso_5.png',
          ),
        ];

      case 'dolorosos':
        return const [
          RosarioMisterioModel(
            tituloCorto: 'Primer Misterio Doloroso',
            titulo: 'La Oración en el Huerto',
            subtitulo: 'Jesús ora en Getsemaní',
            imagePath: 'assets/images/rosario/Dolorosos/doloroso01.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Segundo Misterio Doloroso',
            titulo: 'La Flagelación',
            subtitulo: 'Jesús es azotado',
            imagePath: 'assets/images/rosario/Dolorosos/doloroso02.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Tercer Misterio Doloroso',
            titulo: 'La Coronación de Espinas',
            subtitulo: 'Jesús es coronado con espinas',
            imagePath: 'assets/images/rosario/Dolorosos/doloroso03.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Cuarto Misterio Doloroso',
            titulo: 'Jesús con la Cruz a Cuestas',
            subtitulo: 'Camino al Calvario',
            imagePath: 'assets/images/rosario/Dolorosos/doloroso04.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Quinto Misterio Doloroso',
            titulo: 'La Crucifixión',
            subtitulo: 'Jesús muere en la cruz',
            imagePath: 'assets/images/rosario/Dolorosos/doloroso05.png',
          ),
        ];

      case 'gloriosos':
        return const [
          RosarioMisterioModel(
            tituloCorto: 'Primer Misterio Glorioso',
            titulo: 'La Resurrección',
            subtitulo: 'Jesús resucita glorioso',
            imagePath: 'assets/images/rosario/Gloriosos/glorioso01.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Segundo Misterio Glorioso',
            titulo: 'La Ascensión',
            subtitulo: 'Jesús asciende al cielo',
            imagePath: 'assets/images/rosario/Gloriosos/glorioso02.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Tercer Misterio Glorioso',
            titulo: 'La Venida del Espíritu Santo',
            subtitulo: 'Pentecostés sobre María y los apóstoles',
            imagePath: 'assets/images/rosario/Gloriosos/glorioso03.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Cuarto Misterio Glorioso',
            titulo: 'La Asunción de María',
            subtitulo: 'María es llevada al cielo',
            imagePath: 'assets/images/rosario/Gloriosos/glorioso04.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Quinto Misterio Glorioso',
            titulo: 'La Coronación de María',
            subtitulo: 'María es coronada como Reina del Cielo',
            imagePath: 'assets/images/rosario/Gloriosos/glorioso05.png',
          ),
        ];

      case 'luminosos':
        return const [
          RosarioMisterioModel(
            tituloCorto: 'Primer Misterio Luminoso',
            titulo: 'El Bautismo de Jesús',
            subtitulo: 'Jesús es bautizado en el Jordán',
            imagePath: 'assets/images/rosario/Luminosos/luminoso01.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Segundo Misterio Luminoso',
            titulo: 'Las Bodas de Caná',
            subtitulo: 'Jesús realiza su primer milagro',
            imagePath: 'assets/images/rosario/Luminosos/luminoso02.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Tercer Misterio Luminoso',
            titulo: 'El Anuncio del Reino',
            subtitulo: 'Jesús invita a la conversión',
            imagePath: 'assets/images/rosario/Luminosos/luminoso03.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Cuarto Misterio Luminoso',
            titulo: 'La Transfiguración',
            subtitulo: 'Jesús se manifiesta glorioso',
            imagePath: 'assets/images/Luminosos/luminoso04.png',
          ),
          RosarioMisterioModel(
            tituloCorto: 'Quinto Misterio Luminoso',
            titulo: 'La Institución de la Eucaristía',
            subtitulo: 'Jesús se entrega en el pan y el vino',
            imagePath: 'assets/rosario/images/Luminosos/luminoso05.png',
          ),
        ];

      default:
        return const [
          RosarioMisterioModel(
            tituloCorto: 'Primer Misterio Gozoso',
            titulo: 'La Anunciación',
            subtitulo: 'El ángel Gabriel visita a la Virgen María',
            imagePath: 'assets/rosario/images/Gozosos/gozoso01.png',
          ),
        ];
    }
  }

  static String getPrayerText(String paso) {
    switch (paso) {
      case 'Padre Nuestro':
        return 'Padre nuestro, que estás en el cielo, santificado sea tu Nombre; venga a nosotros tu reino; hágase tu voluntad en la tierra como en el cielo.';
      case 'Ave María':
        return 'Dios te salve, María; llena eres de gracia; el Señor es contigo. Bendita tú eres entre todas las mujeres, y bendito es el fruto de tu vientre, Jesús.';
      case 'Gloria':
        return 'Gloria al Padre, al Hijo y al Espíritu Santo, como era en el principio, ahora y siempre, por los siglos de los siglos. Amén.';
      case 'Jaculatoria':
        return 'María, Madre de gracia, Madre de misericordia, en la vida y en la muerte ampáranos, gran Señora.';
      default:
        return 'Continúa este paso del Santo Rosario con recogimiento y devoción.';
    }
  }
}
