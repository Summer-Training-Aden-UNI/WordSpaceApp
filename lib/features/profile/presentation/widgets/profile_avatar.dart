import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

/// The rounded-square avatar from the design (green ring, optional status
/// dot). Shows [memoryBytes] (a photo just picked), else [imageUrl], else the
/// first letter of [name].
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.memoryBytes,
    this.size = 112,
    this.showStatusDot = true,
  });

  final String name;
  final String? imageUrl;
  final Uint8List? memoryBytes;
  final double size;
  final bool showStatusDot;

  @override
  Widget build(BuildContext context) {
    final initial = Container(
      color: AppColors.sageTint,
      alignment: Alignment.center,
      child: Text(
        name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase(),
        style: AppFonts.headlineXl(color: AppColors.primary),
      ),
    );

    final hasUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    final Widget picture;
    if (memoryBytes != null) {
      picture = Image.memory(
        memoryBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (hasUrl) {
      picture = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => initial,
      );
    } else {
      picture = initial;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: picture,
          ),
        ),
        if (showStatusDot)
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}