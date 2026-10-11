import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../cubit/profile_state.dart';

/// "My Posts | Drafts" switcher (my own profile only).
class ProfileTabs extends StatelessWidget {
  const ProfileTabs({
    super.key,
    required this.selected,
    required this.draftsCount,
    required this.onSelected,
  });

  final ProfileTab selected;
  final int draftsCount;
  final ValueChanged<ProfileTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'My Posts',
            icon: Icons.article_outlined,
            active: selected == ProfileTab.published,
            onTap: () => onSelected(ProfileTab.published),
          ),
          _Segment(
            label: 'Drafts',
            icon: Icons.edit_note_outlined,
            badge: draftsCount,
            active: selected == ProfileTab.drafts,
            onTap: () => onSelected(ProfileTab.drafts),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.badge = 0,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.onSurfaceVariant;

    return Expanded(
      child: Material(
        color: active ? AppColors.surfaceContainerLowest : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        elevation: active ? 1 : 0,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 19, color: color),
                const SizedBox(width: 8),
                Text(label, style: AppFonts.labelLg(color: color)),
                if (badge > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badge',
                      style: AppFonts.labelSm(
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}