import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';

/// What a guest sees when opening "their" profile.
class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key, required this.onSignInTap, this.showBack = true,});

  final VoidCallback onSignInTap;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppTopBar(title: 'Profile', showBack: showBack),
      body: EmptyState(
        title: 'Sign in to see your profile',
        message: 'Write posts, follow authors and keep your favorites '
            'in one place.',
        icon: Icons.person_outline,
        actionLabel: 'Sign in',
        onAction: onSignInTap,
      ),
    );
  }
}