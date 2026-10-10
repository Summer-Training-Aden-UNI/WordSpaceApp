import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  /// 4800 -> "4.8k", 36 -> "36".
  static String compact(int n) {
    if (n < 1000) return '$n';
    final k = (n / 1000).toStringAsFixed(1);
    return '${k.endsWith('.0') ? k.substring(0, k.length - 2) : k}k';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppFonts.headlineMd(color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppFonts.labelSm(color: AppColors.onSurfaceVariant)
                .copyWith(letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}