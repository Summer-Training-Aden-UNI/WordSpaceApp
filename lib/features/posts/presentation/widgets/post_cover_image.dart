import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

/// Full-width cover image with overlay pills.
///
/// Featured card (taller image): dark pills at the bottom —
///   tag on the left, read time on the right.
/// Regular card: one light pill at the top right —
///   the tag if there is one, otherwise the read time.
class PostCoverImage extends StatelessWidget {
  const PostCoverImage({
    super.key,
    required this.imageUrl,
    required this.readTimeMinutes,
    required this.isFeatured,
    this.tag,
  });

  final String imageUrl;
  final int readTimeMinutes;
  final bool isFeatured;
  final String? tag;

  String get _readTime => '$readTimeMinutes min read';

  bool get _hasTag => tag != null && tag!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isFeatured ? 1.6 : 2.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : const _CoverPlaceholder(),
            errorBuilder: (context, error, stackTrace) =>
                const _CoverPlaceholder(icon: Icons.broken_image_outlined),
          ),
          if (isFeatured) ...[
            if (_hasTag)
              Positioned(
                left: 12,
                bottom: 12,
                child: _ImagePill(
                  label: tag!,
                  icon: Icons.bolt,
                  iconColor: Colors.orange,
                  dark: true,
                ),
              ),
            Positioned(
              right: 12,
              bottom: 12,
              child: _ImagePill(label: _readTime, dark: true),
            ),
          ] else
            Positioned(
              top: 12,
              right: 12,
              child: _hasTag
                  // TODO: map a per-category icon once the backend defines
                  // categories. One generic icon for now.
                  ? _ImagePill(label: tag!, icon: Icons.storage_outlined)
                  : _ImagePill(label: _readTime, icon: Icons.timer_outlined),
            ),
        ],
      ),
    );
  }
}

class _ImagePill extends StatelessWidget {
  const _ImagePill({
    required this.label,
    this.icon,
    this.iconColor,
    this.dark = false,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;

  /// Dark translucent pill with white text vs. light pill with dark text.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : AppColors.slate;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: ShapeDecoration(
        color: dark
            ? AppColors.slate.withValues(alpha: 0.65)
            : AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor ?? textColor),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppFonts.labelMd(color: textColor)),
        ],
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({this.icon = Icons.image_outlined});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(icon, size: 32, color: AppColors.placeholder),
    );
  }
}