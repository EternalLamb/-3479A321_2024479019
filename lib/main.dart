import 'package:flutter/material.dart';
import 'package:lab_moviles/app_theme.dart' as app_theme;

import 'ui/screens/PegSolitaireScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Inglés',
      debugShowCheckedModeBanner: false,
      theme: app_theme.AppTheme.lightTheme,
      home: const PegSolitaireScreen(),
    );
  }
}
