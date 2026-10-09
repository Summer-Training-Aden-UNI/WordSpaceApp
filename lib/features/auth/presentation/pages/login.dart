import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/widgets/navigation/app_top_bar.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';
import 'register.dart';
import '../widgets/widgets_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final failure = await context.read<AuthCubit>().login(
      _email.text.trim(),
      _password.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (failure != null) {
      AppSnackBar.error(context, authErrorMessage(failure));
      return;
    }
    // AuthGate swaps the root to Home; remove Welcome/Login from the stack.
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _comingSoon(String what) =>
      AppSnackBar.show(context, '$what is coming soon');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: 'Sign In',
        showBack: true,
        centerTitle: true,
        trailing: CircleIconBadge(icon: Icons.person),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  const BrandHeader(
                    title: 'Welcome Back',
                    subtitle: 'Login to your account to continue',
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabeledTextField(
                          label: 'Email address',
                          controller: _email,
                          hint: 'name@example.com',
                          prefixIcon: Icons.mail_outline,
                          showClear: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || !v.contains('@'))
                              ? 'Enter a valid email'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        LabeledTextField(
                          label: 'Password',
                          trailingLabel: 'Secure',
                          controller: _password,
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter your password'
                              : null,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _comingSoon('Password reset'),
                            child: Text(
                              'Forgot Password?',
                              style: AppFonts.labelMd(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppButton(
                          label: 'Log In',
                          trailingIcon: Icons.arrow_forward,
                          isLoading: _loading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const LabeledDivider(label: 'Or continue with'),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  AuthSwitchPrompt(
                    prompt: "Don't have an account?",
                    actionLabel: 'Sign Up',
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
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

/// Shows the first Laravel 422 field error if there is one.
String authErrorMessage(Failure f) {
  if (f is ServerFailure && f.fieldErrors.isNotEmpty) {
    return f.fieldErrors.values.first.first;
  }
  return f.message;
}
