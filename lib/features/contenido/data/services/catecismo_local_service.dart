import '../models/catecismo_item_model.dart';

class CatecismoLocalService {
  const CatecismoLocalService();

  List<CatecismoItemModel> getItems() {
    return const [
      CatecismoItemModel(
        numero: 1,
        parte: 'CATECISMO DE LA IGLESIA CATÓLICA',
        titulo: 'Dios nos creó\npor amor',
        subtitulo: 'Primer párrafo del Catecismo',
        resumen:
            'Dios, infinitamente perfecto y feliz, creó al ser humano por pura bondad para hacerlo partícipe de su vida divina.',
        explicacion:
            'Dios no nos creó por casualidad ni porque necesitara algo. Nos creó por amor. Eso significa que tu vida tiene propósito, valor y dirección. No eres un error ni una coincidencia. Fuiste pensado por Dios para vivir en amistad con Él.',
        ejemplo:
            'Cuando un joven siente que no encaja, que nadie lo entiende o que su vida no tiene sentido, este párrafo le recuerda que su identidad no depende de los likes, del físico o de la opinión de otros, sino del amor de Dios.',
        aplicacion:
            'No vivo por casualidad; vivo porque Dios me ama y me llamó a la vida con un propósito.',
        reflexion:
            '¿Cómo cambia mi forma de verme a mí mismo saber que Dios me creó por amor?',
        heroImageAsset: 'assets/images/catecismo/cic_1_banner.png',
      ),
      CatecismoItemModel(
        numero: 2,
        parte: 'CATECISMO DE LA IGLESIA CATÓLICA',
        titulo: 'Dios llama\nal hombre',
        subtitulo: 'Segundo párrafo del Catecismo',
        resumen:
            'Dios llama al hombre en todo tiempo y lugar a buscarlo, conocerlo, amarlo y responderle con fe.',
        explicacion:
            'Dios toma la iniciativa en nuestra vida. Antes de que tú lo busques, Él ya te está llamando. Lo hace en la conciencia, en la belleza de la creación, en la Iglesia, en su Palabra y en los acontecimientos de la vida.',
        ejemplo:
            'Cuando un joven empieza a preguntarse por el sentido de su vida, por qué existe o qué quiere Dios de él, ya puede estar experimentando esa llamada interior del Señor.',
        aplicacion:
            'Haz silencio cada día, aunque sea por unos minutos, y pregúntale a Dios qué quiere mostrarte.',
        reflexion: '¿Estoy dejando espacio en mi día para escuchar a Dios?',
        heroImageAsset: 'assets/images/catecismo/cic_2_banner.png',
      ),
      CatecismoItemModel(
        numero: 3,
        parte: 'CATECISMO DE LA IGLESIA CATÓLICA',
        titulo: 'Todos son llamados\na la comunión con Dios',
        subtitulo: 'Tercer párrafo del Catecismo',
        resumen:
            'Todos los hombres están llamados a la comunión con Dios, y la Iglesia existe para anunciar y custodiar esa unión.',
        explicacion:
            'La fe no es solo saber cosas sobre Dios. Es vivir unidos a Él. Y esa unión no se vive aislados. Por eso existe la Iglesia: para reunirnos, alimentarnos con los sacramentos y guiarnos en la verdad.',
        ejemplo:
            'Un joven puede decir: “Yo creo en Dios, pero no necesito la Iglesia”. Este párrafo le ayuda a entender que Cristo quiso salvarnos formando un pueblo, no como personas aisladas.',
        aplicacion:
            'Busca vivir tu fe en comunidad: participa, escucha la Palabra y no camines solo.',
        reflexion:
            '¿Estoy viviendo mi fe solo, o también dentro de la Iglesia?',
        heroImageAsset: 'assets/images/catecismo/cic_3_banner.png',
      ),
    ];
  }
}
