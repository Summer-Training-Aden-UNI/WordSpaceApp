import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/navigation/app_top_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_avatar.dart';

/// Edit my profile: photo, name, username, bio, and Sign out.
/// Needs the same [ProfileCubit] as the Profile page (provided above).
/// Pops with `true` when something was saved.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.onSignOut, this.onSaved});

/// Called after the user confirms "Sign out".
  final VoidCallback? onSignOut;

/// Called after a successful save with the new name and username.
  final void Function(String name, String? username)? onSaved;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // The API accepts jpg, jpeg, png, webp. Its docs list 2 MB for this
  // endpoint (and 5 MB elsewhere), so we use the stricter one.
  static const _maxImageBytes = 2 * 1024 * 1024;
  static const _allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final ProfileInfo? _initial;
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _bio;

  Uint8List? _pickedBytes;
  String? _pickedPath;
  bool _removeAvatar = false;

  @override
  void initState() {
    super.initState();
    _initial = context.read<ProfileCubit>().state.info;
    _name = TextEditingController(text: _initial?.name ?? '');
    _username = TextEditingController(text: _initial?.username ?? '');
    _bio = TextEditingController(text: _initial?.bio ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  bool get _hasPhoto =>
      _pickedBytes != null ||
      (!_removeAvatar && (_initial?.avatarUrl?.trim().isNotEmpty ?? false));

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
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
        AppSnackBar.error(context, 'The photo must be under 2 MB.');
        return;
      }

      setState(() {
        _pickedBytes = bytes;
        _pickedPath = file.path;
        _removeAvatar = false;
      });
    } catch (e) {
      debugPrint('Avatar picker error: $e');
      if (mounted) AppSnackBar.error(context, "Couldn't open your gallery.");
    }
  }

  void _removePhoto() {
    setState(() {
      _pickedBytes = null;
      _pickedPath = null;
      // Only ask the server to delete it if there is a saved photo.
      _removeAvatar = _initial?.avatarUrl?.trim().isNotEmpty ?? false;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final name = _name.text.trim();
    final username = _username.text.trim();
    final bio = _bio.text.trim();

    final nameChanged = name != (_initial?.name ?? '');
    final usernameChanged = username != (_initial?.username ?? '');
    final bioChanged = bio != (_initial?.bio ?? '');
    final avatarChanged = _pickedPath != null || _removeAvatar;

    // Nothing to send.
    if (!nameChanged && !usernameChanged && !bioChanged && !avatarChanged) {
      Navigator.pop(context, false);
      return;
    }

    final saved = await context.read<ProfileCubit>().saveProfile(
          name: name,
          // Only send what changed (the server checks username is unique).
          username: usernameChanged ? username : null,
          bio: bioChanged ? bio : null,
          avatarPath: _pickedPath,
          removeAvatar: _removeAvatar && _pickedPath == null,
        );

    if (!mounted || !saved) return;

    final info = context.read<ProfileCubit>().state.info;
    if (info != null) widget.onSaved?.call(info.name, info.username);

    AppSnackBar.show(context, 'Profile updated');
    Navigator.pop(context, true);
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to post, like and comment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sign out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) widget.onSignOut?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => curr.actionError != null,
      listener: (context, state) =>
          AppSnackBar.error(context, state.actionError!),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: const AppTopBar(title: 'Edit profile', showBack: true),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ProfileAvatar(
                            name: _name.text,
                            imageUrl: _removeAvatar ? null : _initial?.avatarUrl,
                            memoryBytes: _pickedBytes,
                            showStatusDot: false,
                          ),
                          Positioned(
                            right: -6,
                            bottom: -6,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _pickImage,
                        child: Text(
                          'Change photo',
                          style: AppFonts.labelLg(color: AppColors.primary),
                        ),
                      ),
                      if (_hasPhoto)
                        TextButton(
                          onPressed: _removePhoto,
                          child: Text(
                            'Remove photo',
                            style: AppFonts.labelLg(color: AppColors.error),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Name',
                    controller: _name,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}), // updates the initial
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Username',
                    controller: _username,
                    hint: 'e.g. abady',
                    prefixIcon: Icons.alternate_email,
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v != null && v.trim().contains(' '))
                        ? 'Username cannot contain spaces'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Bio',
                    controller: _bio,
                    hint: 'Tell people a little about yourself',
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),
                  ProfileActionButton(
                    label: 'Save changes',
                    icon: Icons.check,
                    isLoading: state.isSaving,
                    onPressed: _save,
                  ),
                  if (widget.onSignOut != null) ...[
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.borderLight),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: _confirmSignOut,
                        icon: const Icon(
                          Icons.logout,
                          size: 18,
                          color: AppColors.error,
                        ),
                        label: Text(
                          'Sign out',
                          style: AppFonts.labelLg(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}