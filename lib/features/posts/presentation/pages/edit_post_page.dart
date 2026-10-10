import 'dart:typed_data';

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

/// Edit my post: title, content, cover and visibility.
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

  Uint8List? _coverPreview;

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

  bool get _hasCover =>
      _coverPreview != null ||
      (widget.post.coverImageUrl?.trim().isNotEmpty ?? false);

  Future<void> _pickCover() async {
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
        AppSnackBar.error(context, 'The cover image must be under 2 MB.');
        return;
      }

      setState(() => _coverPreview = bytes);
      context.read<EditPostCubit>().setImage(file.path);
    } catch (e) {
      debugPrint('Cover picker error: $e');
      if (mounted) AppSnackBar.error(context, "Couldn't open your gallery.");
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<EditPostCubit>().submit(title: _title.text, body: _body.text);
  }

  Widget _cover() {
    final placeholder = Container(
      color: AppColors.sageTint,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.slateMuted),
    );

    if (_coverPreview != null) {
      return Image.memory(_coverPreview!, fit: BoxFit.cover);
    }
    return Image.network(
      widget.post.coverImageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
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

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: const AppTopBar(title: 'Edit post', showBack: true),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  if (_hasCover)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _cover(),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _pickCover,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(
                        _hasCover ? 'Change cover image' : 'Add a cover image',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: 'Title',
                    controller: _title,
                    prefixIcon: Icons.title,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Content',
                    controller: _body,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please write something'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Visibility',
                    style: AppFonts.labelLg(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<PublishStatus>(
                    segments: const [
                      ButtonSegment(
                        value: PublishStatus.published,
                        label: Text('Published'),
                        icon: Icon(Icons.public),
                      ),
                      ButtonSegment(
                        value: PublishStatus.draft,
                        label: Text('Draft'),
                        icon: Icon(Icons.edit_note),
                      ),
                    ],
                    selected: {state.status},
                    onSelectionChanged: (s) => cubit.setStatus(s.first),
                  ),
                  if (state.status == PublishStatus.draft)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A draft is hidden from everyone, including the feed.',
                        style: AppFonts.bodySm(color: AppColors.slateMuted),
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.isSubmitting ? null : _submit,
                    icon: state.isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Save changes'),
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