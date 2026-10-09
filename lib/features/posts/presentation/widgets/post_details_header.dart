import 'package:flutter/material.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';

class PostDetailsHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const PostDetailsHeader({
    super.key,
    this.userName,
    this.userImageUrl,
  });

  final String? userName;
  final String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      title: 'Post Details',
      showBack: true,
      userName: userName,
      userImageUrl: userImageUrl,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}