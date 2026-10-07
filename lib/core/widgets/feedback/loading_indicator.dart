import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Centered brand-colored spinner for full-screen / list loading states.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.brandEmerald,
        strokeWidth: 3,
      ),
    );
  }
}
