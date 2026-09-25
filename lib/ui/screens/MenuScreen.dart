import 'package:flutter/material.dart';

import 'package:lab_moviles/ui/screens/PegSolitaireScreen.dart';
import 'package:lab_moviles/ui/screens/RulesScreen.dart';
import 'package:lab_moviles/ui/screens/HistoryScreen.dart';

import 'package:logger/logger.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Logger _logger = Logger();
    return Scaffold(
      appBar: AppBar(title: const Text('Solitario Inglés')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _logger.i('Navegando a PegSolitaireScreen desde MenuScreen');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PegSolitaireScreen()),
                );
              },
              child: const Text('Jugar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RulesScreen()),
                );
              },
              child: const Text('Reglas del Juego'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: const Text('Historial de Juego'),
            ),
          ],
        ),
      ),
    );
  }
}
