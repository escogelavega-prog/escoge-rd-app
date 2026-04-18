import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildItem(
              index: 0,
              asset: 'assets/icons/home.png',
              label: 'Inicio',
            ),
            _buildItem(
              index: 1,
              asset: 'assets/icons/contenido.png',
              label: 'oraciones',
            ),
            _buildItem(
              index: 2,
              asset: 'assets/icons/retiros.png',
              label: 'Retiros',
            ),
            _buildItem(
              index: 3,
              asset: 'assets/icons/inscripcion.png',
              label: 'contenido',
            ),
            _buildItem(
              index: 4,
              asset: 'assets/icons/perfil.png',
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String asset,
    required String label,
  }) {
    final bool isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isActive ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  asset,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image_outlined,
                      size: 22,
                      color: isActive ? gold : primaryBlue,
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.0,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? gold : primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
