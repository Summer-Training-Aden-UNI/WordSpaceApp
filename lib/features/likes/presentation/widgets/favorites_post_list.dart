import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../posts/domain/entities/post.dart';
import '../cubit/favorites_cubit.dart';
import 'favorite_post_card.dart';

class FavoritesPostList extends StatefulWidget {
  final List<Post> posts;
  final ValueChanged<Post>? onPostTap;

  const FavoritesPostList({
    super.key,
    required this.posts,
    this.onPostTap,
  });

  static const animationDuration = Duration(milliseconds: 280);

  @override
  State<FavoritesPostList> createState() => _FavoritesPostListState();
}

class _FavoritesPostListState extends State<FavoritesPostList> {
  /// Cards that are fading out right now.
  final _removing = <int>{};

  String _short(String title) =>
      title.length <= 24 ? title : '${title.substring(0, 24).trimRight()}…';

  Future<void> _remove(Post post) async {
    if (_removing.contains(post.id)) return;

    final cubit = context.read<FavoritesCubit>();
    final index = widget.posts.indexWhere((p) => p.id == post.id);

    // 1. Play the fade-out.
    setState(() => _removing.add(post.id));
    await Future<void>.delayed(FavoritesPostList.animationDuration);
    if (!mounted) return;

    // 2. Really remove it (and unlike on the server), then offer Undo.
    cubit.removeFavorite(post);
    setState(() => _removing.remove(post.id));

    AppSnackBar.show(
      context,
      'Removed "${_short(post.title)}"',
      actionLabel: 'Undo',
      onAction: () => cubit.restoreFavorite(post, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        final post = widget.posts[index];

        return _RemovableItem(
          key: ValueKey('favorite-${post.id}'),
          removing: _removing.contains(post.id),
          // The gap lives inside the item so it collapses with the card.
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FavoritePostCard(
              post: post,
              onLikeTap: () => _remove(post),
              onReadTap: widget.onPostTap == null
                  ? null
                  : () => widget.onPostTap!(post),
            ),
          ),
        );
      },
    );
  }
}

/// Fades and collapses its child when [removing] turns true.
class _RemovableItem extends StatefulWidget {
  const _RemovableItem({
    super.key,
    required this.removing,
    required this.child,
  });

  final bool removing;
  final Widget child;

  @override
  State<_RemovableItem> createState() => _RemovableItemState();
}

class _RemovableItemState extends State<_RemovableItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: FavoritesPostList.animationDuration,
    value: 1,
  );
  late final Animation<double> _size = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void didUpdateWidget(covariant _RemovableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.removing && !oldWidget.removing) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _size,
      axisAlignment: -1,
      child: FadeTransition(opacity: _controller, child: widget.child),
    );
  }
}