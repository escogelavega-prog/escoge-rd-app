import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LumenSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final double height;

  const LumenSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onChanged,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / items.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                left: itemWidth * selectedIndex,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.lumenGold.withValues(alpha: 0.24),
                        AppColors.lumenGold.withValues(alpha: 0.12),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lumenGold.withValues(alpha: 0.16),
                        blurRadius: 18,
                        spreadRadius: -8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (index) {
                  final active = index == selectedIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onChanged(index);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w500,
                            color: active
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.72),
                          ),
                          child: Text(items[index]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
