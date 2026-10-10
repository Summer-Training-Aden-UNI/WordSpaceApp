import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

enum _OwnerAction { edit, delete }

/// The "..." menu on the author's own post. Edit is hidden when [onEdit]
/// is null.
class PostOwnerMenu extends StatelessWidget {
  const PostOwnerMenu({super.key, this.onEdit, required this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_OwnerAction>(
      tooltip: 'Post options',
      icon: const Icon(Icons.more_horiz, color: AppColors.slate),
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (action) {
        switch (action) {
          case _OwnerAction.edit:
            onEdit?.call();
          case _OwnerAction.delete:
            onDelete();
        }
      },
      itemBuilder: (_) => [
        if (onEdit != null)
          const PopupMenuItem(
            value: _OwnerAction.edit,
            child: _MenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit post',
              color: AppColors.onSurface,
            ),
          ),
        const PopupMenuItem(
          value: _OwnerAction.delete,
          child: _MenuItem(
            icon: Icons.delete_outline,
            label: 'Delete post',
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Text(label, style: AppFonts.labelLg(color: color)),
      ],
    );
  }
}