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
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  void _openEvangelio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EvangelioScreen()),
    );
  }

  void _openLecturas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LecturasScreen()),
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
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0x1AD4AF37),
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Oración',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Retiros',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Contenido',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
