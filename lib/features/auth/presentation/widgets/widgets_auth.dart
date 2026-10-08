import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

// =============================================================================
// CircleIconBadge: small filled circle with an icon (person badge in the bar)
// =============================================================================
class CircleIconBadge extends StatelessWidget {
  const CircleIconBadge({super.key, required this.icon, this.size = 32});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.56, color: AppColors.onPrimary),
    );
  }
}

// =============================================================================
// BrandHeader: logo tile + "WordSpace" + screen title and subtitle
// =============================================================================
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
  });

  final String title;
  final String subtitle;

  /// Small pill next to the name (e.g. "Community"). Shows a dot when null.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.24),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'W',
            style: AppFonts.headlineLg(color: AppColors.onPrimary),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Word',
                    style: AppFonts.headlineMd(color: AppColors.onSurface),
                  ),
                  TextSpan(
                    text: 'Space',
                    style: AppFonts.headlineMd(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: ShapeDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  badge!.toUpperCase(),
                  style: AppFonts.labelSm(color: AppColors.primary)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              )
            else
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(title, style: AppFonts.headlineLg(color: AppColors.onSurface)),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppFonts.bodyMd(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

// =============================================================================
// LabeledTextField: label above, white shadow card, green focus ring
// =============================================================================
class LabeledTextField extends StatefulWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.trailingLabel,
    this.isPassword = false,
    this.showClear = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;

  /// Small text on the right of the label row (e.g. "Secure").
  final String? trailingLabel;
  final bool isPassword;

  /// Shows a clear (x) button at the end of the field.
  final bool showClear;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();
  late bool _obscure = widget.isPassword;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  static const _noBorder = InputBorder.none;

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    Widget? suffix;
    if (widget.isPassword) {
      suffix = IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: AppColors.outline,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    } else if (widget.showClear) {
      suffix = IconButton(
        visualDensity: VisualDensity.compact,
        icon: const Icon(
          Icons.cancel,
          size: 18,
          color: AppColors.outlineVariant,
        ),
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
          _focus.requestFocus();
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: AppFonts.labelMd(color: AppColors.onSurfaceVariant),
                ),
              ),
              if (widget.trailingLabel != null)
                Text(
                  widget.trailingLabel!,
                  style: AppFonts.labelSm(color: AppColors.outline),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              focused
                  ? BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      spreadRadius: 2,
                    )
                  : const BoxShadow(
                      color: Color(0x0A0F172A),
                      blurRadius: 8,
                      spreadRadius: -2,
                      offset: Offset(0, 2),
                    ),
            ],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focus,
            enabled: widget.enabled,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: AppFonts.bodyMd(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: widget.hint,
              filled: false,
              border: _noBorder,
              enabledBorder: _noBorder,
              focusedBorder: _noBorder,
              disabledBorder: _noBorder,
              errorBorder: _noBorder,
              focusedErrorBorder: _noBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: focused ? AppColors.primary : AppColors.outline,
                      ),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// LabeledDivider: hairline divider with centered uppercase text
// =============================================================================
class LabeledDivider extends StatelessWidget {
  const LabeledDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(
      child: Divider(color: AppColors.surfaceContainerHighest, height: 1),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label.toUpperCase(),
            style: AppFonts.labelMd(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ).copyWith(letterSpacing: 1.0),
          ),
        ),
        line,
      ],
    );
  }
}

// =============================================================================
// SocialAuthButton: white card button with a brand mark (Google / Facebook)
// =============================================================================
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  const SocialAuthButton.google({super.key, required this.onPressed})
    : label = 'Google',
      leading = const _GoogleMark();

  const SocialAuthButton.facebook({super.key, required this.onPressed})
    : label = 'Facebook',
      leading = const Icon(Icons.facebook, size: 22, color: Color(0xFF1877F2));

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            spreadRadius: -2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: AppColors.surfaceContainerLow,
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leading,
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppFonts.labelLg(color: AppColors.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple "G" mark. Swap for the real multicolor logo asset if you add one.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: AppFonts.headlineSm(color: const Color(0xFF4285F4))
          .copyWith(fontWeight: FontWeight.w800),
    );
  }
}

// =============================================================================
// AuthSwitchPrompt: "Don't have an account? Sign Up" footer
// =============================================================================
class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: AppFonts.bodyMd(color: AppColors.onSurfaceVariant)),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Text(
            actionLabel,
            style: AppFonts.headlineSm(color: AppColors.primary).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryFixed,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// AuthFormCard: white rounded card that wraps a group of fields
// =============================================================================
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =============================================================================
// FilledTextField: label above, gray filled field, green border on focus
// (meant to sit inside an AuthFormCard)
// =============================================================================
class FilledTextField extends StatefulWidget {
  const FilledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<FilledTextField> createState() => _FilledTextFieldState();
}

class _FilledTextFieldState extends State<FilledTextField> {
  final FocusNode _focus = FocusNode();
  late bool _obscure = widget.isPassword;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  static const _noBorder = InputBorder.none;

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: AppFonts.labelMd(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: focused
                ? AppColors.surfaceContainerLowest
                : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: focused ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focus,
            enabled: widget.enabled,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            style: AppFonts.bodyMd(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppFonts.bodyMd(color: AppColors.outline),
              filled: false,
              border: _noBorder,
              enabledBorder: _noBorder,
              focusedBorder: _noBorder,
              disabledBorder: _noBorder,
              errorBorder: _noBorder,
              focusedErrorBorder: _noBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 14, right: 10),
                      child: Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: AppColors.outline,
                      ),
                    ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.outline,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// TermsCheckbox: "I agree to the Terms of Service & Privacy Policy"
// =============================================================================
class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  late final TapGestureRecognizer _terms = TapGestureRecognizer()
    ..onTap = () => widget.onTermsTap?.call();
  late final TapGestureRecognizer _privacy = TapGestureRecognizer()
    ..onTap = () => widget.onPrivacyTap?.call();

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final link = AppFonts.bodySm(color: AppColors.primary)
        .copyWith(fontWeight: FontWeight.w600);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: widget.value,
            onChanged: (v) => widget.onChanged(v ?? false),
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text.rich(
              TextSpan(
                style: AppFonts.bodySm(color: AppColors.secondary),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: link,
                    recognizer: _terms,
                  ),
                  const TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: link,
                    recognizer: _privacy,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
