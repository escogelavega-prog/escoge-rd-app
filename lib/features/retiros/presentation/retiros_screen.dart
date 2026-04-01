import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:escoge/features/retiros/presentation/retiro_detalle_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetirosScreen extends StatefulWidget {
  const RetirosScreen({super.key});

  @override
  State<RetirosScreen> createState() => _RetirosScreenState();
}

class _RetirosScreenState extends State<RetirosScreen> {
  String _filtroDiocesis = 'Todas';

  Stream<List<RetiroItem>> _streamRetiros() {
    return FirebaseFirestore.instance
        .collection('retiros')
        .where('activo', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();

        final recomendaciones = (data['recomendaciones'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[];

        final imagePath = (data['imagenUrl'] ?? '').toString().trim().isNotEmpty
            ? (data['imagenUrl'] ?? '').toString()
            : 'assets/images/retiro_default.png';

        return RetiroItem(
          id: doc.id,
          titulo: (data['titulo'] ?? '').toString(),
          descripcion: (data['descripcion'] ?? '').toString(),
          ciudad: (data['ciudad'] ?? '').toString(),
          lugar: (data['lugar'] ?? '').toString(),
          fecha: (data['fechaTexto'] ?? '').toString(),
          diocesis: (data['diocesis'] ?? '').toString(),
          categoria: (data['subtitulo'] ?? 'Retiro').toString(),
          recomendaciones: recomendaciones,
          imagePath: imagePath,
          tipoFormulario: (data['tipoFormulario'] ?? 'general').toString(),
        );
      }).toList();

      items.sort((a, b) {
        final aData = snapshot.docs.firstWhere((doc) => doc.id == a.id).data();
        final bData = snapshot.docs.firstWhere((doc) => doc.id == b.id).data();

        final aDestacado = aData['destacado'] == true ? 1 : 0;
        final bDestacado = bData['destacado'] == true ? 1 : 0;

        if (aDestacado != bDestacado) {
          return bDestacado.compareTo(aDestacado);
        }

        final ordenA =
            aData['orden'] is num ? (aData['orden'] as num).toInt() : 9999;
        final ordenB =
            bData['orden'] is num ? (bData['orden'] as num).toInt() : 9999;

        return ordenA.compareTo(ordenB);
      });

      return items;
    });
  }

  List<String> _obtenerDiocesis(List<RetiroItem> retiros) {
    final set = <String>{};

    for (final retiro in retiros) {
      final diocesis = retiro.diocesis.trim();
      if (diocesis.isNotEmpty) {
        set.add(diocesis);
      }
    }

    final lista = set.toList()..sort();
    return ['Todas', ...lista];
  }

  List<RetiroItem> _aplicarFiltro(List<RetiroItem> retiros) {
    if (_filtroDiocesis == 'Todas') return retiros;

    return retiros.where((r) => r.diocesis.trim() == _filtroDiocesis).toList();
  }

  void _abrirDetalle(RetiroItem retiro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RetiroDetalleScreen(retiro: retiro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Retiros',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<RetiroItem>>(
        stream: _streamRetiros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          if (snapshot.hasError) {
            return const _ErrorState(
              message: 'No se pudieron cargar los retiros.',
            );
          }

          final retiros = snapshot.data ?? [];
          final diocesisDisponibles = _obtenerDiocesis(retiros);
          final retirosFiltrados = _aplicarFiltro(retiros);

          if (!diocesisDisponibles.contains(_filtroDiocesis)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _filtroDiocesis = 'Todas';
                });
              }
            });
          }

          if (retiros.isEmpty) {
            return const _EmptyState();
          }

          return Column(
            children: [
              _HeaderResumen(
                total: retirosFiltrados.length,
                filtroDiocesis: _filtroDiocesis,
              ),
              _FiltroDiocesisBar(
                opciones: diocesisDisponibles,
                seleccionado: _filtroDiocesis,
                onSelected: (value) {
                  setState(() {
                    _filtroDiocesis = value;
                  });
                },
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: retirosFiltrados.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final retiro = retirosFiltrados[index];

                    return _RetiroCard(
                      retiro: retiro,
                      onTap: () => _abrirDetalle(retiro),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderResumen extends StatelessWidget {
  final int total;
  final String filtroDiocesis;

  const _HeaderResumen({
    required this.total,
    required this.filtroDiocesis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Encuentra tu próximo retiro',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            filtroDiocesis == 'Todas'
                ? '$total retiro(s) disponibles'
                : '$total retiro(s) en $filtroDiocesis',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroDiocesisBar extends StatelessWidget {
  final List<String> opciones;
  final String seleccionado;
  final ValueChanged<String> onSelected;

  const _FiltroDiocesisBar({
    required this.opciones,
    required this.seleccionado,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: opciones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = opciones[index];
          final isSelected = item == seleccionado;

          return ChoiceChip(
            label: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.primaryBlue,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(item),
            selectedColor: AppColors.primaryBlue,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primaryBlue
                  : AppColors.primaryBlue.withValues(alpha: 0.18),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          );
        },
      ),
    );
  }
}

class _RetiroCard extends StatelessWidget {
  final RetiroItem retiro;
  final VoidCallback onTap;

  const _RetiroCard({
    required this.retiro,
    required this.onTap,
  });

  bool get _isNetworkImage {
    final path = retiro.imagePath.trim().toLowerCase();
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    retiro.titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (retiro.categoria.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      retiro.categoria,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                  if (retiro.descripcion.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      retiro.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (retiro.diocesis.trim().isNotEmpty)
                    _InfoRow(
                      icon: Icons.church_rounded,
                      text: retiro.diocesis,
                    ),
                  if (retiro.ciudad.trim().isNotEmpty)
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      text: retiro.ciudad,
                    ),
                  if (retiro.lugar.trim().isNotEmpty)
                    _InfoRow(
                      icon: Icons.place_rounded,
                      text: retiro.lugar,
                    ),
                  if (retiro.fecha.trim().isNotEmpty)
                    _InfoRow(
                      icon: Icons.calendar_month_rounded,
                      text: retiro.fecha,
                    ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      retiro.tipoFormulario == 'fds'
                          ? 'Ver retiro FDS'
                          : 'Ver retiro',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final path = retiro.imagePath.trim();

    if (path.isEmpty) {
      return _fallbackImage();
    }

    if (_isNetworkImage) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            Color(0xFF3658C9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.terrain_rounded,
        size: 56,
        color: Colors.white,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13.2,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 18),
            Text(
              'No hay retiros disponibles',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando se publiquen nuevos retiros aparecerán aquí automáticamente.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 62,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
