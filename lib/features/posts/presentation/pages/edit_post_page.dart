import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/post.dart';
import '../cubit/create_post_cubit.dart' show PublishStatus;
import '../cubit/edit_post_cubit.dart';
import '../widgets/post_form_widgets.dart';

/// Edit my post. Looks exactly like the Create Post page (same fields, cover
/// picker and publishing options), filled with the post's current values.
/// Pops with an [EditPostResult] when it was saved.
class EditPostPage extends StatelessWidget {
  const EditPostPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditPostCubit(original: post, updatePost: sl()),
      child: _EditPostView(post: post),
    );
  }
}

class _EditPostView extends StatefulWidget {
  const _EditPostView({required this.post});

  final Post post;

  @override
  State<_EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<_EditPostView> {
  static const _maxImageBytes = 2 * 1024 * 1024; // the API's limit
  static const _allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _title;
  late final TextEditingController _body;

  /// Preview of a newly picked cover (web needs the bytes).
  Uint8List? _newCoverBytes;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.post.title);
    _body = TextEditingController(
      text: widget.post.body.trim().isNotEmpty
          ? widget.post.body
          : widget.post.excerpt,
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  /// The cover the post has now (null when it has none).
  String? get _existingCoverUrl {
    final url = widget.post.coverImageUrl?.trim();
    return (url == null || url.isEmpty) ? null : url;
  }

  Future<void> _pickCover() async {
    final cubit = context.read<EditPostCubit>();

    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;

      final name = file.name.toLowerCase();
      if (!_allowedExtensions.any(name.endsWith)) {
        AppSnackBar.error(context, 'Please choose a JPG, PNG or WebP image.');
        return;
      }

      final bytes = await file.readAsBytes();
      if (!mounted) return;

      if (bytes.length > _maxImageBytes) {
        AppSnackBar.error(context, 'The image must be under 2MB.');
        return;
      }

      setState(() => _newCoverBytes = bytes);
      cubit.setImage(file.path);
    } catch (e) {
      debugPrint('Cover picker error: $e');
      if (mounted) AppSnackBar.error(context, "Couldn't open your gallery.");
    }
  }

  /// The X on a newly picked cover: back to the one the post already has.
  void _discardNewCover() {
    setState(() => _newCoverBytes = null);
    context.read<EditPostCubit>().discardNewImage();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<EditPostCubit>().submit(title: _title.text, body: _body.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPostCubit, EditPostState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null ||
          (curr.result != null && prev.result != curr.result),
      listener: (context, state) {
        final error = state.errorMessage;
        if (error != null) AppSnackBar.error(context, error);

        final result = state.result;
        if (result != null) Navigator.pop(context, result);
      },
      builder: (context, state) {
        final cubit = context.read<EditPostCubit>();
        final isPublish = state.status == PublishStatus.published;
        final hasCover = state.imagePath != null || _existingCoverUrl != null;

        return Scaffold(
          appBar: const AppTopBar(title: 'Edit post', showBack: true),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  PostFormTextField(
                    label: 'Post Title',
                    isRequired: true,
                    controller: _title,
                    hint: 'Enter your post title...',
                    maxLength: 100,
                    textInputAction: TextInputAction.next,
                    errorText: state.fieldError('title'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  PostCoverPicker(
                    label:
                        hasCover ? 'Cover Image' : 'Add Cover Image (Optional)',
                    imagePath: state.imagePath,
                    imageBytes: _newCoverBytes,
                    existingImageUrl: _existingCoverUrl,
                    errorText: state.fieldError('image'),
                    onPick: _pickCover,
                    onRemove: _discardNewCover,
                  ),
                  const SizedBox(height: 20),
                  PostFormTextField(
                    label: 'Content',
                    isRequired: true,
                    controller: _body,
                    hint:
                        'Share your thoughts, tutorials, or insights with '
                        'the community...',
                    maxLength: 1000,
                    minLines: 6,
                    maxLines: 12,
                    errorText:
                        state.fieldError('content') ??
                        state.fieldError('body'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please write something'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Publishing Options'),
                  const SizedBox(height: 12),
                  PostPublishOptionTile(
                    icon: Icons.public,
                    title: 'Publish',
                    subtitle: 'Make your post visible to everyone',
                    selected: isPublish,
                    onTap: () => cubit.setStatus(PublishStatus.published),
                  ),
                  const SizedBox(height: 12),
                  PostPublishOptionTile(
                    icon: Icons.description_outlined,
                    title: 'Save as Draft',
                    subtitle: 'Hide it from everyone until you publish again',
                    selected: !isPublish,
                    onTap: () => cubit.setStatus(PublishStatus.draft),
                  ),
                  if (!isPublish)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A draft is removed from the feed and your profile.',
                        style: AppFonts.bodySm(color: AppColors.slateMuted),
                      ),
                    ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: isPublish ? 'Save Changes' : 'Save as Draft',
                    icon: Icons.save_outlined,
                    trailingIcon: Icons.save_outlined,
                    isLoading: state.isSubmitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}