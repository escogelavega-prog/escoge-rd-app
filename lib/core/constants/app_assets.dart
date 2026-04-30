class AppAssets {
  AppAssets._();

  // =========================
  // LOGOS OFICIALES
  // =========================
  static const String logo = 'assets/icons/logo.png';
  static const String logoMovimiento = 'assets/images/logo_movimiento.png';

  // =========================
  // ICONOS BOTTOM NAV / CORE
  // =========================
  static const String homeIcon = 'assets/icons/home.png';
  static const String oracionIcon = 'assets/icons/oracion.png';
  static const String contenidoIcon = 'assets/icons/contenido.png';
  static const String retirosIcon = 'assets/icons/retiros.png';
  static const String perfilIcon = 'assets/icons/perfil.png';

  // =========================
  // ICONOS SECUNDARIOS / MODULOS
  // =========================
  static const String bibliaIcon = 'assets/icons/biblia.png';
  static const String catecismoIcon = 'assets/icons/catecismo.png';
  static const String peticionesIcon = 'assets/icons/peticiones.png';
  static const String calendarioIcon = 'assets/icons/calendario.png';
  static const String evangelioIcon = 'assets/icons/evangelio.png';
  static const String rosarioIcon = 'assets/icons/rosario.png';
  static const String santoIcon = 'assets/icons/santo.png';

  // =========================
  // UI PREMIUM / DECORACION
  // =========================
  static const String btnPrimarioDorado = 'assets/ui/btn_primario_dorado.png';

  static const String btnSecundarioOutline =
      'assets/ui/btn_secundario_outline.png';

  static const String frameLectorSuperior =
      'assets/ui/frame_lector_superior.png';

  static const String separadorSeccion = 'assets/ui/separador_seccion.png';

  // =========================
  // BACKGROUNDS OFICIALES
  // =========================
  static const String fondoUniforme = 'assets/backgrounds/bg_primary.png';

  static const String homeBackground = 'assets/backgrounds/home.png';

  static const String onboardingBackground =
      'assets/backgrounds/onboarding_bg.png';

  static const String perfilBackground = 'assets/backgrounds/perfil_bg.png';

  static const String bibliaBackground = 'assets/backgrounds/biblia_bg.png';

  static const String oracionBackground = 'assets/backgrounds/oracion_bg.png';

  // =========================
  // LITURGIA / LECTURAS
  // =========================
  static const String evangelioHoy = 'assets/lecturas/evangelio.jpg';

  static const String evangelioManana = 'assets/lecturas/evangelio1.jpg';

  static const String santoDefault = 'assets/lecturas/santo_default.jpg';

  // =========================
  // ROSARIO / AUDIOVISUAL
  // =========================
  static const String rosarioFondo = 'assets/rosario/rosario_fondo.png';

  static const String rosarioCruz = 'assets/rosario/cruz.png';

  // =========================
  // SPLASH / ENTRY
  // =========================
  static const String splashLogo = 'assets/icons/logo_movimiento.png';

  // =========================
  // HELPERS DINAMICOS
  // =========================
  static String evangelioPorIndice(int index) {
    switch (index) {
      case 1:
        return evangelioManana;
      case 0:
      default:
        return evangelioHoy;
    }
  }
}
