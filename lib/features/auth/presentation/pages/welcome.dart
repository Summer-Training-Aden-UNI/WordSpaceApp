import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/widgets.dart'; // AppButton, AppButtonVariant
import '../cubit/auth_cubit.dart';
import 'login.dart';
import 'register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.brandEmerald,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    'W',
                    style: AppFonts.headlineXl(color: AppColors.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Word',
                      style: AppFonts.headlineXl(color: AppColors.slate),
                    ),
                    TextSpan(
                      text: 'Space',
                      style: AppFonts.headlineXl(color: AppColors.brandEmerald),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Read, write and follow the people you like.',
                textAlign: TextAlign.center,
                style: AppFonts.bodyLg(color: AppColors.slateMuted),
              ),
              const Spacer(flex: 3),
              AppButton(
                label: 'Log in',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const LoginPage())),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create account',
                variant: AppButtonVariant.outlined,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const RegisterPage())),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.read<AuthCubit>().continueAsGuest(),
                child: Text(
                  'Continue as guest',
                  style: AppFonts.labelLg(color: AppColors.slateMuted),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
