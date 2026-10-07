import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Circular avatar: shows the network image, or the user's first letter
/// while loading / when there is no image / when loading fails.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 40,
  });

  final String name;
  final String? imageUrl;
  final double size;

  String get _initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initial = Center(
      child: Text(
        _initial,
        style: AppFonts.labelLg(color: AppColors.primary)
            .copyWith(fontSize: size * 0.4),
      ),
    );

    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.sageTint,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: hasImage
          ? Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : initial,
              errorBuilder: (context, error, stackTrace) => initial,
            )
          : initial,
    );
  }
}
