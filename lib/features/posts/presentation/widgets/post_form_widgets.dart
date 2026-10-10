import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

// Form widgets shared by the Create Post and Edit Post pages, so the two
// screens look exactly the same.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.isRequired = false,
    this.trailing,
  });

  final String label;
  final bool isRequired;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: label,
              style: AppFonts.labelLg(color: AppColors.onSurface),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppFonts.labelLg(color: AppColors.error),
                  ),
              ],
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class PostFormTextField extends StatefulWidget {
  const PostFormTextField({
    required this.label,
    required this.controller,
    required this.maxLength,
    this.hint,
    this.isRequired = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
    this.validator,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final int maxLength;
  final String? hint;
  final bool isRequired;
  final int minLines;
  final int maxLines;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? errorText;

  @override
  State<PostFormTextField> createState() => _PostFormTextFieldState();
}

class _PostFormTextFieldState extends State<PostFormTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final multiline = widget.maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          label: widget.label,
          isRequired: widget.isRequired,
          trailing: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) => Text(
              '${value.text.characters.length}/${widget.maxLength}',
              style: AppFonts.labelMd(color: AppColors.slateMuted),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (value) {
            setState(() => _focused = value);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _focused
                  ? const [
                      BoxShadow(color: AppColors.focusGlow, spreadRadius: 4),
                    ]
                  : const [],
            ),
            child: TextFormField(
              controller: widget.controller,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: multiline
                  ? TextInputType.multiline
                  : TextInputType.text,
              textInputAction: widget.textInputAction,
              textCapitalization: TextCapitalization.sentences,
              validator: widget.validator,
              style: AppFonts.bodyMd(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: widget.hint,
                errorText: widget.errorText,
                counterText: '',
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Cover image field, shared by the Create and Edit post pages.
///
/// It shows one of three things:
///  * a newly picked image ([imagePath]) with an X to discard it,
///  * the cover the post already has ([existingImageUrl], Edit only) with a
///    "Change" button,
///  * the dashed "add an image" box.
class PostCoverPicker extends StatelessWidget {
  const PostCoverPicker({
    super.key,
    required this.onPick,
    required this.onRemove,
    this.imagePath,
    this.imageBytes,
    this.existingImageUrl,
    this.errorText,
    this.label = 'Add Cover Image (Optional)',
    this.formatsLabel = 'JPG, PNG, WebP',
    this.maxMb = 2,
  });

  /// A newly picked file (null = nothing new picked).
  final String? imagePath;
  final Uint8List? imageBytes;

  /// The cover the post already has (Edit page).
  final String? existingImageUrl;

  final VoidCallback onPick;

  /// Discards the newly picked image.
  final VoidCallback onRemove;
  final String? errorText;

  final String label;
  final String formatsLabel;
  final int maxMb;

  @override
  Widget build(BuildContext context) {
    final hasExisting =
        existingImageUrl != null && existingImageUrl!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          label: label,
          trailing: Text.rich(
            TextSpan(
              text: '$formatsLabel · ',
              style: AppFonts.bodySm(color: AppColors.slateMuted),
              children: [
                TextSpan(
                  text: 'max ${maxMb}MB',
                  style: AppFonts.labelMd(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (imagePath != null)
          _buildPicked()
        else if (hasExisting)
          _buildExisting()
        else
          _buildEmpty(),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: AppFonts.bodySm(color: AppColors.error)),
        ],
      ],
    );
  }

  Widget _buildEmpty() {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(color: AppColors.outlineVariant),
      child: Material(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPick,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppFonts.headlineSm(color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to upload a $formatsLabel image\n'
                  'up to ${maxMb}MB',
                  textAlign: TextAlign.center,
                  style: AppFonts.bodySm(color: AppColors.slateMuted),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: const Text('Choose File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A newly picked image, with an X to discard it.
  Widget _buildPicked() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: onPick,
              child: kIsWeb
                  ? (imageBytes != null
                        ? Image.memory(imageBytes!, fit: BoxFit.cover)
                        : const Center(
                            child: Text('Image preview unavailable'),
                          ))
                  : Image.file(File(imagePath!), fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: AppColors.slate.withValues(alpha: 0.65),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The cover the post already has. There is no X: the API can only
  /// replace a cover from this form, not remove it.
  Widget _buildExisting() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: onPick,
              child: Image.network(
                existingImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.surfaceContainerHigh,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Material(
                color: AppColors.slate.withValues(alpha: 0.65),
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onPick,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Change',
                          style: AppFonts.labelMd(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  static const _radius = 16.0;
  static const _dash = 6.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(_radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

class PostPublishOptionTile extends StatelessWidget {
  const PostPublishOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.sageTint : AppColors.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppColors.primaryFixedDim : AppColors.borderLight,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.primaryFixed
                      : AppColors.surfaceContainer,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? AppColors.onPrimaryFixedVariant
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.headlineSm(color: AppColors.onSurface),
                    ),
                    Text(
                      subtitle,
                      style: AppFonts.bodySm(color: AppColors.slateMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _RadioDot(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.white : AppColors.surfaceContainerHigh,
        border: selected
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}