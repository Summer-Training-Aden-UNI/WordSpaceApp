import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../cubit/profile_state.dart';
import 'profile_avatar.dart';
import 'profile_stat_card.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.info,
    required this.followersCount,
    required this.action,
  });

  final ProfileInfo info;
  final int followersCount;

  /// Follow / Following / Edit profile button.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final username = info.username?.trim() ?? '';
    final bio = info.bio?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(name: info.name, imageUrl: info.avatarUrl),
          const SizedBox(height: 16),
          Text(info.name, style: AppFonts.headlineLg(color: AppColors.onSurface)),
          if (username.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text('@$username', style: AppFonts.labelMd(color: AppColors.primary)),
          ],
          if (bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              bio,
              style: AppFonts.bodyMd(color: AppColors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 16),
          action,
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  value: ProfileStatCard.compact(info.postsCount),
                  label: 'Posts',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProfileStatCard(
                  value: ProfileStatCard.compact(followersCount),
                  label: 'Followers',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}