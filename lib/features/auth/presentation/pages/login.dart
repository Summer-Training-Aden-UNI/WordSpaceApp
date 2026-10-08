import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart'; // login/register (authErrorMessage)


import '../../../../core/widgets/widgets.dart'; // AppButton, AppTextField, AppSnackBar
import '../../../../core/widgets/navigation/app_top_bar.dart'; // NOT exported by widgets.dart
import '../cubit/auth_cubit.dart';
import 'register.dart'; // RegisterPage + authErrorMessage

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: 'Sign In',
        showBack: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _password,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter your password' : null,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Log in',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Text("Don't have an account? Create one"),
                ),
              ],
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
