import 'package:flutter/material.dart';

import 'navigation/app_top_bar.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: title, showBack: true),
      body: const Center(child: Text('Coming soon')),
    );
  }
}