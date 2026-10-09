import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../cubit/create_post_cubit.dart';

/// Create Post screen. Pops with the created [Post] on success.
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key, this.userName, this.userImageUrl});

  final String? userName;
  final String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreatePostCubit>(),
      child: _CreatePostView(userName: userName, userImageUrl: userImageUrl),
    );
  }
}

class _CreatePostView extends StatefulWidget {
  const _CreatePostView({this.userName, this.userImageUrl});

  final String? userName;
  final String? userImageUrl;

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView> {
  static const _maxImageBytes = 5 * 1024 * 1024;
  static const _allowedExtensions = ['.jpg', '.jpeg', '.png'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final cubit = context.read<CreatePostCubit>();
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;

      final name = file.name.toLowerCase();
      if (!_allowedExtensions.any(name.endsWith)) {
        AppSnackBar.error(context, 'Please choose a JPG or PNG image.');
        return;
      }
      if (await file.length() > _maxImageBytes) {
        if (mounted) AppSnackBar.error(context, 'The image must be under 5MB.');
        return;
      }
      cubit.setImage(file.path);
    } catch (_) {
      if (mounted) AppSnackBar.error(context, 'Couldn\'t open your gallery.');
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<CreatePostCubit>().submit(
      title: _titleController.text,
      body: _bodyController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null || curr.createdPost != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.error(context, state.errorMessage!);
        }
        final post = state.createdPost;
        if (post != null) {
          AppSnackBar.show(
            context,
            state.status == PublishStatus.published
                ? 'Post published'
                : 'Draft saved',
          );
          Navigator.of(context).pop(post);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreatePostCubit>();
        final isPublish = state.status == PublishStatus.published;

        return Scaffold(
          appBar: AppTopBar(
            title: 'Add',
            showBack: true,
            userName: widget.userName,
            userImageUrl: widget.userImageUrl,
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _CounterTextField(
                    label: 'Post Title',
                    isRequired: true,
                    controller: _titleController,
                    hint: 'Enter your post title...',
                    maxLength: 100,
                    textInputAction: TextInputAction.next,
                    errorText: state.fieldError('title'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _CoverImagePicker(
                    imagePath: state.imagePath,
                    errorText: state.fieldError('image'),
                    onPick: _pickImage,
                    onRemove: cubit.removeImage,
                  ),
                  const SizedBox(height: 20),
                  _CounterTextField(
                    label: 'Content',
                    isRequired: true,
                    controller: _bodyController,
                    hint:
                        'Share your thoughts, tutorials, or insights with '
                        'the community...',
                    maxLength: 1000,
                    minLines: 6,
                    maxLines: 12,
                    errorText: state.fieldError('body'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please write something'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Publishing Options'),
                  const SizedBox(height: 12),
                  _PublishOptionTile(
                    icon: Icons.public,
                    title: 'Publish',
                    subtitle: 'Make your post visible to everyone',
                    selected: isPublish,
                    onTap: () => cubit.setStatus(PublishStatus.published),
                  ),
                  const SizedBox(height: 12),
                  _PublishOptionTile(
                    icon: Icons.description_outlined,
                    title: 'Save as Draft',
                    subtitle: 'Keep it private and finish editing later',
                    selected: !isPublish,
                    onTap: () => cubit.setStatus(PublishStatus.draft),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: isPublish ? 'Publish Post' : 'Save Draft',
                    icon: isPublish ? Icons.send_outlined : Icons.save_outlined,
                    trailingIcon: isPublish
                        ? Icons.send_outlined
                        : Icons.save_outlined,
                    isLoading: state.isSubmitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
          // Hidden while typing, so it doesn't ride above the keyboard.
          bottomNavigationBar: keyboardOpen
              ? null
              : BottomNavBar(
                  currentTab: NavTab.create,
                  onTabSelected: (tab) {
                    if (tab != NavTab.create) Navigator.of(context).maybePop();
                  },
                ),
        );
      },
    );
  }
}

// =============================================================================
// Private widgets used only by this page
// =============================================================================

/// Label row above a field: "Post Title *" on the left, optional trailing
/// widget (counter, hint...) on the right.
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
        ?trailing,
      ],
    );
  }
}

/// Text field with the label above it and a live "12/100" counter.
/// Fill, borders and hint style come from AppTheme (inputDecorationTheme).
class _CounterTextField extends StatefulWidget {
  const _CounterTextField({
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

  /// Server-side error (Laravel 422). The [validator] error wins if both exist.
  final String? errorText;

  @override
  State<_CounterTextField> createState() => _CounterTextFieldState();
}

class _CounterTextFieldState extends State<_CounterTextField> {
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
          onFocusChange: (v) => setState(() => _focused = v),
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
                counterText: '', // we draw our own counter in the label row
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "Add Cover Image (Optional)" block: dashed upload box, or a preview of the
/// chosen image with a remove button. Picking is done by the parent.
class _CoverImagePicker extends StatelessWidget {
  const _CoverImagePicker({
    required this.imagePath,
    required this.onPick,
    required this.onRemove,
    this.errorText,
  });

  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          label: 'Add Cover Image (Optional)',
          trailing: Text.rich(
            TextSpan(
              text: 'JPG, PNG · ',
              style: AppFonts.bodySm(color: AppColors.slateMuted),
              children: [
                TextSpan(
                  text: 'max 5MB',
                  style: AppFonts.labelMd(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        imagePath == null ? _buildEmpty() : _buildPreview(),
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
                  'Add Cover Image (Optional)',
                  textAlign: TextAlign.center,
                  style: AppFonts.headlineSm(color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to upload or drag & drop JPG,\nPNG up to 5MB',
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

  Widget _buildPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: onPick, // tap the image to change it
              child: Image.file(File(imagePath!), fit: BoxFit.cover),
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

/// One radio-style card in "Publishing Options" (Publish / Save as Draft).
class _PublishOptionTile extends StatelessWidget {
  const _PublishOptionTile({
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
