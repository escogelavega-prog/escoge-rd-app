import 'package:escoge/core/widgets/custom_bottom_nav.dart';
import 'package:escoge/features/contenido/presentation/contenido_screen.dart';
import 'package:escoge/features/home/presentation/home_screen.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/presentation/oracion_screen.dart';
import 'package:escoge/features/perfil/presentation/perfil_screen.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    if (!mounted) return;
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _openEvangelio() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const EvangelioScreen(),
      ),
    );
  }

  void _openLecturas() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const LecturasScreen(),
      ),
    );
  }

  late final List<Widget> _screens = [
    HomeScreen(
      onOpenOracion: () => _goToTab(1),
      onOpenRetiros: () => _goToTab(2),
      onOpenContenido: () => _goToTab(3),
      onOpenEvangelio: _openEvangelio,
      onOpenLecturas: _openLecturas,
      onOpenHistoria: () => _goToTab(3),
      onOpenPerfil: () => _goToTab(4),
    ),
    const OracionScreen(),
    const RetirosScreen(),
    const ContenidoScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}
