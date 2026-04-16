import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _shellBackground = Color(0xFF09102B);
  static const Color _navBackground = Color(0xFF1E234B);
  static const Color _navBorder = Color(0xFF4B509B);
  static const Color _activePill = Color(0xFF50547E);
  static const Color _activeGold = Color(0xFFD4AF37);
  static const Color _inactive = Color(0xFFE8EAF6);

  @override
  Widget build(BuildContext context) {
    final mainItems = <_NavItemData>[
      const _NavItemData(icon: Icons.home_rounded, label: 'Inicio'),
      const _NavItemData(icon: Icons.auto_awesome_rounded, label: 'Oración'),
      const _NavItemData(icon: Icons.groups_rounded, label: 'Retiros'),
      const _NavItemData(icon: Icons.grid_view_rounded, label: 'Contenido'),
    ];

    const perfilItem = _NavItemData(
      icon: Icons.person_rounded,
      label: 'Perfil',
    );

    return Container(
      color: _shellBackground,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _GlassNavCapsule(
                child: Row(
                  children: List.generate(mainItems.length, (index) {
                    final item = mainItems[index];
                    final isActive = currentIndex == index;

                    return Expanded(
                      child: _NavButton(
                        item: item,
                        isActive: isActive,
                        onTap: () => onTap(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 76,
              child: _GlassNavCapsule(
                active: currentIndex == 4,
                child: _NavButton(
                  item: perfilItem,
                  isActive: currentIndex == 4,
                  onTap: () => onTap(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassNavCapsule extends StatelessWidget {
  final Widget child;
  final bool active;

  const _GlassNavCapsule({
    required this.child,
    this.active = false,
  });

  static const Color _navBackground = Color(0xFF1E234B);
  static const Color _navBorder = Color(0xFF4B509B);
  static const Color _activePill = Color(0xFF50547E);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: (active ? _activePill : _navBackground).withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _navBorder.withValues(alpha: 0.55),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  static const Color _activePill = Color(0xFF50547E);
  static const Color _activeGold = Color(0xFFD4AF37);
  static const Color _inactive = Color(0xFFE8EAF6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? _activePill.withValues(alpha: 0.55)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive
                    ? _activeGold.withValues(alpha: 0.14)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: isActive ? _activeGold : _inactive,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? _activeGold : _inactive,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.label,
  });
}
