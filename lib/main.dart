import 'package:flutter/material.dart';
import 'package:lab_moviles/app_theme.dart' as app_theme;
import 'package:lab_moviles/ui/screens/PegSolitaireScreen.dart';
import 'package:lab_moviles/ui/screens/RulesScreen.dart';
import 'package:lab_moviles/ui/screens/HistoryScreen.dart';

import 'ui/screens/MenuScreen.dart';

void main() {
  runApp(const PegSolitaireApp());
}

class PegSolitaireApp extends StatelessWidget {
  const PegSolitaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Inicia en la ruta del menú
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => PegSolitaireScreen(),
        '/history': (context) => const HistoryScreen(),
        '/rules': (context) => const RulesScreen(),
      },
    );
  }
}
