import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/widgets/navigation/app_top_bar.dart';

import '../../../../core/widgets/widgets.dart'; // AppButton, AppSnackBar, AppTopBar
import '../cubit/auth_cubit.dart';
import '../widgets/widgets_auth.dart';
import 'login.dart'; // LoginPage + authErrorMessage

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _agreed = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      AppSnackBar.error(context, 'Please accept the Terms and Privacy Policy');
      return;
    }
    setState(() => _loading = true);

    final failure = await context.read<AuthCubit>().register(
      name: _name.text.trim(),
      username: _username.text.trim().replaceFirst(RegExp(r'^@'), ''),
      email: _email.text.trim(),
      password: _password.text,
      passwordConfirmation: _confirm.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (failure != null) {
      AppSnackBar.error(context, authErrorMessage(failure));
      return;
    }
    // AuthGate swaps the root to Home; remove Welcome/Register from the stack.
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _comingSoon(String what) =>
      AppSnackBar.show(context, '$what is coming soon');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: 'Sign Up',
        showBack: true,
        centerTitle: true,
        trailing: CircleIconBadge(icon: Icons.person),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  const BrandHeader(
                    title: 'Create Your Account',
                    subtitle: 'Join our community and start sharing your ideas',
                    badge: 'Community',
                  ),
                  const SizedBox(height: 24),
                  AuthFormCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledTextField(
                            label: 'Full Name',
                            controller: _name,
                            hint: 'e.g. Abdullah',
                            prefixIcon: Icons.person_outline,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter your name'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          FilledTextField(
                            label: 'Username',
                            controller: _username,
                            hint: '@abdullah',
                            prefixIcon: Icons.alternate_email,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().length < 3)
                                ? 'At least 3 characters'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          FilledTextField(
                            label: 'Email Address',
                            controller: _email,
                            hint: 'abdullah@gmail.com',
                            prefixIcon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || !v.contains('@'))
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          FilledTextField(
                            label: 'Password',
                            controller: _password,
                            hint: 'Create password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.length < 8)
                                ? 'At least 8 characters'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          FilledTextField(
                            label: 'Confirm Password',
                            controller: _confirm,
                            hint: 'Repeat password',
                            prefixIcon: Icons.lock_reset,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                            validator: (v) => v != _password.text
                                ? 'Passwords do not match'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TermsCheckbox(
                            value: _agreed,
                            onChanged: (v) => setState(() => _agreed = v),
                            onTermsTap: () => _comingSoon('Terms of Service'),
                            onPrivacyTap: () => _comingSoon('Privacy Policy'),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Get Started',
                            trailingIcon: Icons.arrow_forward,
                            isLoading: _loading,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthSwitchPrompt(
                    prompt: 'Already have an account?',
                    actionLabel: 'Log In',
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
