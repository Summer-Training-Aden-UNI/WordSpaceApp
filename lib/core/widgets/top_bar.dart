import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import 'user_avatar.dart';

/// WordSpace top app bar used on all main screens (Home, Search, Profile …).
///
/// Left side  : app logo + page title (e.g. "Home", "Profile").
/// Right side : user avatar (tappable).
///
/// Implements [PreferredSizeWidget] so it can be used as a Scaffold's
/// [appBar], or placed inside a [Column] / [SliverAppBar] as needed.
///
/// Usage:
/// ```dart
/// TopBar(
///   title: 'Home',
///   userName: user.name,
///   userImageUrl: user.imageUrl,
///   onAvatarTap: () => navigateToProfile(),
/// )
/// ```
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.leading,
  });

  /// Page title shown below the brand name (e.g. "Home", "Profile").
  final String title;

  /// User name for the avatar fallback initial.
  final String? userName;

  /// Network URL for the user's profile picture.
  final String? userImageUrl;

  /// Callback when the avatar is tapped.
  final VoidCallback? onAvatarTap;

  /// Optional leading widget to replace the default logo.
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          // ---- Left: logo + title ----
          leading ?? _buildLogo(),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Word',
                      style: AppFonts.labelLg(color: AppColors.slate),
                    ),
                    TextSpan(
                      text: 'Space',
                      style: AppFonts.labelLg(color: AppColors.brandEmerald),
                    ),
                  ],
                ),
              ),
              Text(
                title,
                style: AppFonts.labelSm(color: AppColors.slateMuted),
              ),
            ],
          ),

          const Spacer(),

          // ---- Right: avatar ----
          if (userName != null)
            GestureDetector(
              onTap: onAvatarTap,
              child: UserAvatar(
                name: userName!,
                imageUrl: userImageUrl,
                size: 36,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.brandEmerald,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'W',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
