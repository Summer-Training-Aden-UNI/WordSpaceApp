import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../follow/domain/entities/public_user.dart';

/// One person in the search results. Tapping opens their profile
/// (that is where the Follow button lives).
class SearchUserTile extends StatelessWidget {
  const SearchUserTile({super.key, required this.user, this.onTap});

  final PublicUser user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final username = user.username;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            UserAvatar(name: user.name, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.labelLg(color: AppColors.slate),
                  ),
                  if (username != null && username.isNotEmpty)
                    Text(
                      '@$username',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.bodySm(color: AppColors.slateMuted),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.slateMuted,
            ),
          ],
        ),
      ),
    );
  }
}
