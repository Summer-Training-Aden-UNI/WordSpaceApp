import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('wordspace'))),
    ),
  );
}
