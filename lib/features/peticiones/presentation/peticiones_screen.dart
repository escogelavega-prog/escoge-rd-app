import 'package:escoge/features/peticiones/services/peticiones_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/peticiones/data/models/peticion_model.dart';
import 'package:escoge/features/peticiones/presentation/nueva_peticion_screen.dart';
import 'package:escoge/features/peticiones/widgets/peticion_card.dart';

class PeticionesScreen extends StatefulWidget {
  const PeticionesScreen({super.key});

  @override
  State<PeticionesScreen> createState() => _PeticionesScreenState();
}

class _PeticionesScreenState extends State<PeticionesScreen> {
  final PeticionesService _service = PeticionesService();

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepBlue = Color(0xFF0B1E66);

  Future<void> _openNuevaPeticion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NuevaPeticionScreen(),
      ),
    );
  }

  Future<void> _unirseAOracion(PeticionModel peticion) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _service.unirseAOracion(
        peticionId: peticion.id,
        userId: user.uid,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te has unido a esta oración.'),
        ),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo registrar tu apoyo: $e'),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 2),
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _gold.withValues(alpha: 0.10),
            border: Border.all(
              color: _gold.withValues(alpha: 0.16),
            ),
          ),
          child: const Icon(
            Icons.volunteer_activism_rounded,
            color: _gold,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Peticiones',
          textAlign: TextAlign.center,
          style: GoogleFonts.lora(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w700,
            height: 1.02,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Unidos en oración como comunidad.\nComparte tus intenciones o únete\nen oración.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 13.3,
              fontWeight: FontWeight.w500,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _gold.withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: _gold,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Aún no hay peticiones',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en compartir una intención con la comunidad.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 12.8,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _openNuevaPeticion,
            icon: const Icon(Icons.add_rounded, size: 17),
            label: const Text('Nueva petición'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: _deepBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No se pudieron cargar las peticiones.',
            style: GoogleFonts.poppins(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.toString() ?? 'Error desconocido',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.76),
              fontSize: 12.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeticionesList(List<PeticionModel> peticiones) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;

    return Column(
      children: peticiones.map((peticion) {
        if (currentUserId == null) {
          return PeticionCard(
            peticion: peticion,
            yaUnido: false,
            onUnirse: () {},
          );
        }

        return FutureBuilder<bool>(
          future: _service.yaSeUnio(
            peticionId: peticion.id,
            userId: currentUserId,
          ),
          builder: (context, snapshot) {
            final yaUnido = snapshot.data ?? false;

            return PeticionCard(
              peticion: peticion,
              yaUnido: yaUnido,
              onUnirse: () => _unirseAOracion(peticion),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _openNuevaPeticion,
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: _gold,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    size: 17,
                    color: _deepBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Nueva petición',
                    style: GoogleFonts.poppins(
                      color: _deepBlue,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/form.png',
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.24),
                    _deepBlue.withValues(alpha: 0.16),
                    Colors.black.withValues(alpha: 0.48),
                    Colors.black.withValues(alpha: 0.68),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: StreamBuilder<List<PeticionModel>>(
              stream: _service.getPeticionesPublicadas(),
              builder: (context, snapshot) {
                final peticiones = snapshot.data ?? const <PeticionModel>[];

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (snapshot.hasError)
                      _buildErrorState(snapshot.error)
                    else if (peticiones.isEmpty)
                      _buildEmptyState()
                    else
                      _buildPeticionesList(peticiones),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
