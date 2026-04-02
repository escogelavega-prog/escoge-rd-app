import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenOracion;
  final VoidCallback? onOpenContenido;
  final VoidCallback? onOpenRetiros;

  const HomeScreen({
    super.key,
    this.onOpenOracion,
    this.onOpenContenido,
    this.onOpenRetiros,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  bool _isLoading = true;
  Map<String, dynamic>? _liturgia;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLiturgia();
  }

  Future<void> _loadLiturgia() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _liturgiaService.obtenerLiturgiaDelDia();

      if (!mounted) return;

      setState(() {
        _liturgia = data;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo cargar la liturgia del día.';
        _isLoading = false;
      });
    }
  }

  String _saludoPorHora() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _textoSeguro(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  Map<String, dynamic>? _mapSeguro(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF0B1E66);
    const royalBlue = Color(0xFF1736A2);
    const softBlueBg = Color(0xFFF3F6FD);

    final evangelio = _mapSeguro(_liturgia?['evangelio']);
    final reflexion = _mapSeguro(_liturgia?['reflexion']);
    final santo = _mapSeguro(_liturgia?['santoDelDia']);

    final celebracion = _textoSeguro(_liturgia?['celebracion']);
    final tiempoLiturgico = _textoSeguro(_liturgia?['tiempoLiturgico']);
    final colorLiturgico = _textoSeguro(_liturgia?['colorLiturgico']);
    final tituloDia = _textoSeguro(
      _liturgia?['tituloDia'],
      fallback: 'Hoy en la Iglesia',
    );

    final evangelioTitulo = _textoSeguro(
      evangelio?['titulo'],
      fallback: 'Evangelio del día',
    );
    final evangelioCita = _textoSeguro(evangelio?['cita']);
    final evangelioTexto = _textoSeguro(evangelio?['texto']);

    final reflexionTitulo = _textoSeguro(
      reflexion?['titulo'],
      fallback: 'Reflexión del día',
    );
    final reflexionTexto = _textoSeguro(reflexion?['texto']);

    final santoNombre = _textoSeguro(
      santo?['nombre'],
      fallback: 'Santo del día',
    );
    final santoDescripcion = _textoSeguro(santo?['descripcionBreve']);
    final santoFrase = _textoSeguro(santo?['frase']);

    return Scaffold(
      backgroundColor: softBlueBg,
      body: RefreshIndicator(
        onRefresh: _loadLiturgia,
        color: deepBlue,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [deepBlue, royalBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopHeader(
                          saludo: _saludoPorHora(),
                          subtitle: 'Escoge RD',
                        ),
                        const SizedBox(height: 20),
                        _HeroLiturgico(
                          tituloDia: tituloDia.isNotEmpty
                              ? tituloDia
                              : 'Hoy en la Iglesia',
                          celebracion: celebracion.isNotEmpty
                              ? celebracion
                              : 'Contenido litúrgico diario',
                          tiempoLiturgico: tiempoLiturgico,
                          colorLiturgico: colorLiturgico,
                          onPressed: widget.onOpenOracion,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -14),
                child: Container(
                  decoration: const BoxDecoration(
                    color: softBlueBg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionHeader(
                          title: 'Camino del día',
                          subtitle:
                              'Una experiencia espiritual cuidada, clara y cercana.',
                        ),
                        const SizedBox(height: 16),
                        if (_isLoading)
                          const _LoadingBlock()
                        else if (_error != null)
                          _ErrorCard(
                            message: _error!,
                            onRetry: _loadLiturgia,
                          )
                        else ...[
                          _EvangelioPreviewCard(
                            cita: evangelioCita,
                            titulo: evangelioTitulo,
                            extracto: evangelioTexto,
                            onPressed: widget.onOpenOracion,
                          ),
                          const SizedBox(height: 16),
                          _QuickActionsRow(
                            onOpenOracion: widget.onOpenOracion,
                            onOpenContenido: widget.onOpenContenido,
                            onOpenRetiros: widget.onOpenRetiros,
                          ),
                          const SizedBox(height: 20),
                          const _SectionHeader(
                            title: 'Profundiza hoy',
                            subtitle:
                                'Liturgia, santidad y reflexión en una sola vista.',
                          ),
                          const SizedBox(height: 16),
                          _SantoDelDiaCard(
                            nombre: santoNombre,
                            descripcion: santoDescripcion,
                            frase: santoFrase,
                          ),
                          const SizedBox(height: 16),
                          _ReflexionCard(
                            titulo: reflexionTitulo,
                            texto: reflexionTexto,
                            onPressed:
                                widget.onOpenContenido ?? widget.onOpenOracion,
                          ),
                          const SizedBox(height: 18),
                          _MainActionBanner(
                            title: 'Sigue tu camino espiritual',
                            subtitle:
                                'Explora el evangelio, las lecturas del día y los próximos retiros.',
                            onPrimaryTap: widget.onOpenOracion,
                            onSecondaryTap: widget.onOpenRetiros,
                          ),
                        ],
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String saludo;
  final String subtitle;

  const _TopHeader({
    required this.saludo,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const gold = Color(0xFFD4AF37);

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: white.withOpacity(0.15),
            ),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: gold,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saludo,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: white.withOpacity(0.80),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  color: white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: white.withOpacity(0.10),
            ),
          ),
          child: Text(
            'Home',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroLiturgico extends StatelessWidget {
  final String tituloDia;
  final String celebracion;
  final String tiempoLiturgico;
  final String colorLiturgico;
  final VoidCallback? onPressed;

  const _HeroLiturgico({
    required this.tituloDia,
    required this.celebracion,
    required this.tiempoLiturgico,
    required this.colorLiturgico,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const gold = Color(0xFFD4AF37);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            white.withOpacity(0.10),
            white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: white.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tituloDia,
              style: GoogleFonts.poppins(
                color: gold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            celebracion,
            style: GoogleFonts.lora(
              color: white,
              fontSize: 25,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (tiempoLiturgico.isNotEmpty) _MiniChip(text: tiempoLiturgico),
              if (colorLiturgico.isNotEmpty)
                _MiniChip(text: 'Color: $colorLiturgico'),
            ],
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color: Color(0xFF0B1E66),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Abrir liturgia del día',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0B1E66),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;

  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EvangelioPreviewCard extends StatelessWidget {
  final String cita;
  final String titulo;
  final String extracto;
  final VoidCallback? onPressed;

  const _EvangelioPreviewCard({
    required this.cita,
    required this.titulo,
    required this.extracto,
    this.onPressed,
  });

  String _recortarTexto(String value, {int max = 180}) {
    if (value.length <= max) return value;
    return '${value.substring(0, max).trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);
    const gold = Color(0xFFD4AF37);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: deepBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: deepBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Evangelio del día',
                  style: GoogleFonts.poppins(
                    color: textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  cita.isNotEmpty ? cita : 'Liturgia',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF8A6A00),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            titulo,
            style: GoogleFonts.lora(
              color: textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            extracto.isNotEmpty
                ? _recortarTexto(extracto)
                : 'Hoy puedes profundizar en el mensaje del Evangelio, con una lectura contemplativa y elegante dentro del módulo de Oración.',
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 13.5,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: deepBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Entrar al evangelio',
                    style: GoogleFonts.poppins(
                      color: white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final VoidCallback? onOpenOracion;
  final VoidCallback? onOpenContenido;
  final VoidCallback? onOpenRetiros;

  const _QuickActionsRow({
    this.onOpenOracion,
    this.onOpenContenido,
    this.onOpenRetiros,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.self_improvement_rounded,
            title: 'Oración',
            subtitle: 'Liturgia y fe',
            onTap: onOpenOracion,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.auto_stories_rounded,
            title: 'Contenido',
            subtitle: 'Reflexiones',
            onTap: onOpenContenido,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.groups_rounded,
            title: 'Retiros',
            subtitle: 'Encuentros',
            onTap: onOpenRetiros,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: deepBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: deepBlue,
                size: 21,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SantoDelDiaCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String frase;

  const _SantoDelDiaCard({
    required this.nombre,
    required this.descripcion,
    required this.frase,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);
    const gold = Color(0xFFD4AF37);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gold.withOpacity(0.22),
                  deepBlue.withOpacity(0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: deepBlue,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Santo del día',
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  nombre.isNotEmpty ? nombre : 'Santo del día',
                  style: GoogleFonts.lora(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (descripcion.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 13,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (frase.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    '“$frase”',
                    style: GoogleFonts.lora(
                      color: deepBlue,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflexionCard extends StatelessWidget {
  final String titulo;
  final String texto;
  final VoidCallback? onPressed;

  const _ReflexionCard({
    required this.titulo,
    required this.texto,
    this.onPressed,
  });

  String _recortarTexto(String value, {int max = 180}) {
    if (value.length <= max) return value;
    return '${value.substring(0, max).trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);
    const textPrimary = Color(0xFF1B2559);
    const textSecondary = Color(0xFF667085);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.isNotEmpty ? titulo : 'Reflexión del día',
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            texto.isNotEmpty
                ? _recortarTexto(texto)
                : 'Una breve reflexión puede ayudarte a vivir el mensaje del día con más profundidad, belleza y sentido espiritual.',
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 13.5,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seguir leyendo',
                  style: GoogleFonts.poppins(
                    color: deepBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: deepBlue,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainActionBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  const _MainActionBanner({
    required this.title,
    required this.subtitle,
    this.onPrimaryTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF0B1E66);
    const royalBlue = Color(0xFF1736A2);
    const gold = Color(0xFFD4AF37);
    const white = Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [deepBlue, royalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: deepBlue.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              color: white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: white.withOpacity(0.85),
              fontSize: 13,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GestureDetector(
                onTap: onPrimaryTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Abrir oración',
                    style: GoogleFonts.poppins(
                      color: deepBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSecondaryTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: gold.withOpacity(0.20),
                    ),
                  ),
                  child: Text(
                    'Ver retiros',
                    style: GoogleFonts.poppins(
                      color: white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            color: deepBlue,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando liturgia del día...',
            style: GoogleFonts.poppins(
              color: const Color(0xFF667085),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const deepBlue = Color(0xFF0B1E66);
    const textSecondary = Color(0xFF667085);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: deepBlue,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: deepBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Intentar de nuevo',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
