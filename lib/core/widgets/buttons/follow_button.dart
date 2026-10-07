import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Compact pill button that toggles between **+ Follow** and **✓ Following**.
///
/// Place this on post cards, user list tiles, and profile headers. It handles
/// its own visual state — the parent just passes [isFollowing] and a callback.
///
/// While [isLoading] is true a small spinner replaces the label so the user
/// knows the request is in flight.
///
/// Usage:
/// ```dart
/// FollowButton(
///   isFollowing: user.isFollowing,
///   isLoading: store.isToggling,
///   onPressed: () => store.toggle(user.id),
/// )
/// ```
class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.isFollowing,
    this.isLoading = false,
    required this.onPressed,
  });

  final bool isFollowing;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Avoid flipping visuals mid-request: keep the *current* look while loading.
    final following = isFollowing;

    return SizedBox(
      height: 32,
      child: Material(
        color: following ? AppColors.surfaceContainer : Colors.transparent,
        shape: StadiumBorder(
          side: following
              ? BorderSide.none
              : const BorderSide(color: AppColors.brandEmerald, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          splashColor:
              following ? AppColors.borderLight : AppColors.sageTint,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: following
                          ? AppColors.slateMuted
                          : AppColors.brandEmerald,
                    ),
                  )
                else ...[
                  Icon(
                    following ? Icons.check : Icons.add,
                    size: 16,
                    color: following
                        ? AppColors.slateMuted
                        : AppColors.brandEmerald,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    following ? 'Following' : 'Follow',
                    style: AppFonts.labelMd(
                      color: following
                          ? AppColors.slateMuted
                          : AppColors.brandEmerald,
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
