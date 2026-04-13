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
  static const Color _secondaryBlue = Color(0xFF1736A2);

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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _gold.withValues(alpha: 0.16),
            border: Border.all(
              color: _gold.withValues(alpha: 0.28),
            ),
          ),
          child: const Icon(
            Icons.volunteer_activism_rounded,
            color: _gold,
            size: 32,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Peticiones',
          textAlign: TextAlign.center,
          style: GoogleFonts.lora(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Unidos en oración como comunidad.\nComparte tus intenciones o únete en oración.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _deepBlue.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _gold.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _gold.withValues(alpha: 0.14),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: _gold,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Aún no hay peticiones',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en compartir una intención con la comunidad.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.76),
              fontSize: 13.2,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _openNuevaPeticion,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva petición'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: _deepBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _deepBlue.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(24),
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
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            error?.toString() ?? 'Error desconocido',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12.5,
              height: 1.45,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNuevaPeticion,
        backgroundColor: _gold,
        foregroundColor: _deepBlue,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva petición'),
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
                    Colors.black.withValues(alpha: 0.14),
                    _deepBlue.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.40),
                    Colors.black.withValues(alpha: 0.56),
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
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
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
