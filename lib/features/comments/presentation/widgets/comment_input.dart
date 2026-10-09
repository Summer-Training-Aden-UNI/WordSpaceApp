import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Text box + send button.
///
/// [onSubmit] must return `true` when the comment was really sent; only then
/// the box is cleared (so a failed send doesn't lose what the user typed).
class CommentInput extends StatefulWidget {
  const CommentInput({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final Future<bool> Function(String text) onSubmit;
  final bool isSubmitting;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();

  bool get _canSend =>
      _controller.text.trim().isNotEmpty && !widget.isSubmitting;

  @override
  void initState() {
    super.initState();
    // Rebuild on every keystroke so the send button enables / disables.
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSend) return;
    final sent = await widget.onSubmit(_controller.text);
    if (sent && mounted) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: !widget.isSubmitting,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Add a comment...'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: _canSend ? _submit : null,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.brandEmerald,
            foregroundColor: AppColors.onPrimary,
          ),
          tooltip: 'Send',
          icon: widget.isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onPrimary,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 20),
        ),
      ],
    );
  }
}
