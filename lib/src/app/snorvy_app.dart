import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snorvy/src/app/snorvy_controller.dart';
import 'package:snorvy/src/features/shell/snorvy_shell.dart';
import 'package:snorvy/src/theme/snorvy_theme.dart';

class SnorvyApp extends StatefulWidget {
  const SnorvyApp({super.key, this.controller});

  final SnorvyController? controller;

  @override
  State<SnorvyApp> createState() => _SnorvyAppState();
}

class _SnorvyAppState extends State<SnorvyApp> {
  late final bool _ownsController = widget.controller == null;
  late final SnorvyController _controller =
      widget.controller ?? SnorvyController.production();

  @override
  void initState() {
    super.initState();
    unawaited(_controller.initialize());
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snorvy',
      debugShowCheckedModeBanner: false,
      theme: SnorvyTheme.light(),
      darkTheme: SnorvyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: SnorvyShell(controller: _controller),
    );
  }
}
