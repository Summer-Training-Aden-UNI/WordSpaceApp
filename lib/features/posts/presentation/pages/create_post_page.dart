import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../cubit/create_post_cubit.dart';
import '../widgets/post_form_widgets.dart';

/// Create Post screen. Pops with the created Post on success.
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
  static const _maxImageBytes = 2 * 1024 * 1024; // the API's limit
  static const _allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _picker = ImagePicker();

  Uint8List? _selectedImageBytes;

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
        AppSnackBar.error(context, 'Please choose a JPG, PNG or WebP image.');
        return;
      }

      final bytes = await file.readAsBytes();

      if (bytes.length > _maxImageBytes) {
        if (mounted) {
          AppSnackBar.error(context, 'The image must be under 2MB.');
        }
        return;
      }

      setState(() {
        _selectedImageBytes = bytes;
      });

      cubit.setImage(file.path);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Couldn\'t open your gallery.');
      }
      debugPrint('Image picker error: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
    });

    context.read<CreatePostCubit>().removeImage();
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
      listenWhen: (previous, current) =>
          current.errorMessage != null || current.createdPost != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.error(context, state.errorMessage!);
        }

        final post = state.createdPost;

        if (post != null) {
          final message = state.status == PublishStatus.published
              ? 'Post published successfully!'
              : 'Draft saved successfully!';

          AppSnackBar.show(context, message);
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
                  PostFormTextField(
                    label: 'Post Title',
                    isRequired: true,
                    controller: _titleController,
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
                    imagePath: state.imagePath,
                    imageBytes: _selectedImageBytes,
                    errorText: state.fieldError('image'),
                    onPick: _pickImage,
                    onRemove: _removeImage,
                  ),
                  const SizedBox(height: 20),
                  PostFormTextField(
                    label: 'Content',
                    isRequired: true,
                    controller: _bodyController,
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
          bottomNavigationBar: keyboardOpen
              ? null
              : BottomNavBar(
                  currentTab: NavTab.create,
                  onTabSelected: (tab) {
                    if (tab != NavTab.create) {
                      Navigator.of(context).maybePop(tab);
                    }
                  },
                ),
        );
      },
    );
  }
}