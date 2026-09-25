import 'package:flutter/material.dart';
import 'package:lab_moviles/models/GameRecord.dart';
import 'package:lab_moviles/ui/screens/HistoryScreen.dart';

class PegSolitaireScreen extends StatefulWidget {
  const PegSolitaireScreen({super.key});

  @override
  State<PegSolitaireScreen> createState() => _PegSolitaireScreenState();
}

class _PegSolitaireScreenState extends State<PegSolitaireScreen> {
  // Lista donde se almacenan los registros de partidas jugadas en la sesión
  final List<GameRecord> _gameHistory = [];

  // Método para guardar una nueva partida finalizada
  void _saveGameRecord({
    required int remainingPegs,
    required int totalMoves,
    required int durationSeconds,
    required bool isVictory,
  }) {
    final newRecord = GameRecord(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      remainingPegs: remainingPegs,
      totalMoves: totalMoves,
      durationSeconds: durationSeconds,
      isVictory: isVictory,
    );

    setState(() {
      _gameHistory.insert(
        0,
        newRecord,
      ); // Agrega al inicio para mostrar primero la más reciente
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solitario de Clavijas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver Historial',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(records: _gameHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Pantalla de Juego!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Botón de prueba para simular la finalización de una partida
            ElevatedButton(
              onPressed: () {
                _saveGameRecord(
                  remainingPegs: 1,
                  totalMoves: 31,
                  durationSeconds: 120,
                  isVictory: true,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Partida simulada guardada en el historial'),
                  ),
                );
              },
              child: const Text('Simular Ganar Partida'),
            ),
          ],
        ),
      ),
    );
  }
}
