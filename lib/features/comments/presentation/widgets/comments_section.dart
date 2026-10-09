import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../state/comments_cubit.dart';
import '../state/comments_state.dart';
import 'comment_input.dart';
import 'comment_tile.dart';

/// The whole comments area of the Post Details page.
///
/// ```dart
/// CommentsSection(
///   postId: post.id,                 // int
///   currentUserId: me.id,            // lets the user delete their own comments
///   initialCount: post.commentCount,
/// )
/// ```
///
/// It is NOT a scrolling list: it is a Column meant to live inside the page's
/// own scroll view (SingleChildScrollView / CustomScrollView).
class CommentsSection extends StatelessWidget {
  const CommentsSection({
    super.key,
    required this.postId,
    this.currentUserId,
    this.initialCount = 0,
  });

  final int postId;
  final int? currentUserId;
  final int initialCount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The one place where the service locator is used.
      create: (_) => CommentsCubit(
        postId: postId,
        initialCount: initialCount,
        getComments: sl(),
        addComment: sl(),
        deleteComment: sl(),
      )..load(),
      child: _CommentsView(currentUserId: currentUserId),
    );
  }
}

class _CommentsView extends StatelessWidget {
  const _CommentsView({required this.currentUserId});

  final int? currentUserId;

  Future<void> _confirmDelete(BuildContext context, int commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete comment?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CommentsCubit>().deleteComment(commentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommentsCubit>();

    return BlocConsumer<CommentsCubit, CommentsState>(
      // One snackbar per failed add / delete / load more.
      listenWhen: (prev, curr) =>
          curr.actionError != null && prev.actionError != curr.actionError,
      listener: (context, state) =>
          AppSnackBar.error(context, state.actionError!),
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(count: state.commentsCount),
            const SizedBox(height: 12),
            switch (state.status) {
              CommentsStatus.initial || CommentsStatus.loading => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: LoadingIndicator(),
                ),
              CommentsStatus.failure => ErrorView(
                  message: state.errorMessage ??
                      'We couldn\'t load the comments. Try again.',
                  onRetry: cubit.load,
                ),
              CommentsStatus.success => _Loaded(
                  state: state,
                  currentUserId: currentUserId,
                  onDelete: (id) => _confirmDelete(context, id),
                ),
            },
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Comments', style: AppFonts.headlineSm(color: AppColors.slate)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.sageTint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: AppFonts.labelSm(color: AppColors.brandEmerald),
          ),
        ),
      ],
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.state,
    required this.currentUserId,
    required this.onDelete,
  });

  final CommentsState state;
  final int? currentUserId;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommentsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentInput(
          onSubmit: cubit.addComment,
          isSubmitting: state.isSubmitting,
        ),
        const SizedBox(height: 8),
        if (state.comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: EmptyState(
              title: 'No comments yet',
              message: 'Be the first to share your thoughts.',
              icon: Icons.chat_bubble_outline,
            ),
          )
        else
          for (final comment in state.comments) ...[
            CommentTile(
              key: ValueKey(comment.id),
              comment: comment,
              canDelete:
                  currentUserId != null && comment.authorId == currentUserId,
              isDeleting: state.deletingIds.contains(comment.id),
              onDelete: () => onDelete(comment.id),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
          ],
        if (state.hasMore)
          Center(
            child: state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: cubit.loadMore,
                    child: const Text('Load more comments'),
                  ),
          ),
      ],
    );
  }
}
