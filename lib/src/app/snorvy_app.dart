import 'package:flutter/material.dart';
import 'package:snorvy/src/features/shell/snorvy_shell.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class SnorvyApp extends StatelessWidget {
  const SnorvyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snorvy',
      debugShowCheckedModeBanner: false,
      theme: SnorvyTheme.light(),
      darkTheme: SnorvyTheme.dark(),
      home: const SnorvyShell(),
    );
  }
}
