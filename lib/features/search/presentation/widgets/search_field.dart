import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Rounded search box with a search icon and an X button (shown only while
/// there is text). It owns its text controller; the page only gets callbacks.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    this.hint = 'Search posts and people...',
    this.autofocus = false,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final String hint;
  final bool autofocus;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() {}); // hide the X
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        setState(() {}); // show / hide the X
        widget.onChanged(value);
      },
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.brandEmerald),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: _clear,
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.slateMuted,
                tooltip: 'Clear',
              ),
      ),
    );
  }
}
