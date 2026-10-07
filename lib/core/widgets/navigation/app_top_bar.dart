import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../display/user_avatar.dart';

/// WordSpace top app bar. Replaces both `TopBar` and `BackTopBar`.
///
/// **Brand mode** (`showBack: false`, default) — root tab screens
/// (Home, Search, Profile):
///   logo + "WordSpace" + small [title] below it, avatar on the right.
///
/// **Back mode** (`showBack: true`) — pushed screens (Post Details, Login,
/// Create Account, Edit Profile, Add Post, Author Profile):
///   back arrow + [title], avatar / [trailing] on the right.
///   The title sits next to the arrow by default; pass `centerTitle: true`
///   to center it (the Sign In / Sign Up designs).
///
/// The right side shows [trailing] if given, otherwise the avatar when
/// [userName] is given, otherwise nothing.
///
/// Implements [PreferredSizeWidget] so it works as `Scaffold.appBar`.
///
/// Usage:
/// ```dart
/// // root tabs
/// AppTopBar(
///   title: 'Home',
///   userName: user.name,
///   userImageUrl: user.avatarUrl,
///   onAvatarTap: goToProfile,
/// )
///
/// // pushed screens
/// AppTopBar(title: 'Post Details', showBack: true, userName: user.name)
/// const AppTopBar(title: 'Sign In', showBack: true, centerTitle: true)
/// ```
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.centerTitle = false,
    this.onBack,
    this.userName,
    this.userImageUrl,
    this.onAvatarTap,
    this.trailing,
    this.leading,
  });

  /// Brand mode: small label under "WordSpace" ("Home", "Profile").
  /// Back mode: the screen title ("Post Details", "Sign In").
  final String title;

  /// `true` shows the back arrow + title layout.
  final bool showBack;

  /// Back mode only: center the title instead of placing it next to the arrow.
  final bool centerTitle;

  /// Back arrow action. Defaults to `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Name used for the avatar's fallback initial. No name = no avatar.
  final String? userName;

  /// Network URL for the avatar image.
  final String? userImageUrl;

  /// Called when the avatar is tapped.
  final VoidCallback? onAvatarTap;

  /// Replaces the avatar on the right side (e.g. an icon button).
  final Widget? trailing;

  /// Brand mode only: replaces the default "W" logo square.
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Back mode is slightly translucent and has less left padding because
      // the IconButton already brings its own padding.
      color: showBack
          ? AppColors.surface.withValues(alpha: 0.85)
          : AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: showBack ? 8 : 16,
        right: 16,
        bottom: 8,
      ),
      child: showBack ? _buildBackBar(context) : _buildBrandBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // Right side (shared by both modes)
  // ---------------------------------------------------------------------------

  Widget? _buildRight({required double avatarSize}) {
    if (trailing != null) return trailing;
    if (userName == null) return null;
    return GestureDetector(
      onTap: onAvatarTap,
      child: UserAvatar(
        name: userName!,
        imageUrl: userImageUrl,
        size: avatarSize,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Brand mode: logo + WordSpace + subtitle ........ avatar
  // ---------------------------------------------------------------------------

  Widget _buildBrandBar() {
    final right = _buildRight(avatarSize: 36);
    return Row(
      children: [
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
            Text(title, style: AppFonts.labelSm(color: AppColors.slateMuted)),
          ],
        ),
        const Spacer(),
        ?right,
      ],
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
      child: Center(
        child: Text(
          'W',
          style: AppFonts.labelLg(color: AppColors.onPrimary),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Back mode: [<-]  title ........ avatar
  // With centerTitle the right side gets a slot as wide as the IconButton (48)
  // so the title stays truly centered.
  // ---------------------------------------------------------------------------

  Widget _buildBackBar(BuildContext context) {
    final right = _buildRight(avatarSize: 32);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          color: AppColors.onSurface,
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          splashRadius: 22,
          tooltip: 'Back',
        ),
        Expanded(
          child: Text(
            title,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.headlineSm(color: AppColors.onSurface),
          ),
        ),
        if (centerTitle)
          SizedBox(
            width: 48,
            child: Align(alignment: Alignment.centerRight, child: right),
          )
        else
         ?right,
      ],
    );
  }
}
