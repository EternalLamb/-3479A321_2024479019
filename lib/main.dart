import 'package:flutter/material.dart';
import 'package:lab_moviles/models/GameRecord.dart';
import 'package:lab_moviles/ui/screens/HistoryScreen.dart';
import 'package:lab_moviles/ui/screens/MenuScreen.dart';
import 'package:lab_moviles/ui/screens/PegSolitaireScreen.dart';
import 'package:lab_moviles/ui/screens/RulesScreen.dart';

void main() {
  runApp(const PegSolitaireApp());
}

class PegSolitaireApp extends StatelessWidget {
  const PegSolitaireApp({super.key});

  // Lista manual con 10 registros de partidas creadas previamente
  List<GameRecord> _generateInitialHistory() {
    return [
      GameRecord(
        id: 'REC-001',
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 145, // 02:25
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-002',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        remainingPegs: 4,
        totalMoves: 22,
        durationSeconds: 98, // 01:38
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-003',
        date: DateTime.now().subtract(const Duration(hours: 8)),
        remainingPegs: 1,
        totalMoves: 35,
        durationSeconds: 210, // 03:30
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-004',
        date: DateTime.now().subtract(const Duration(days: 1)),
        remainingPegs: 6,
        totalMoves: 15,
        durationSeconds: 65, // 01:05
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-005',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        remainingPegs: 2,
        totalMoves: 29,
        durationSeconds: 180, // 03:00
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-006',
        date: DateTime.now().subtract(const Duration(days: 2)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 122, // 02:02
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-007',
        date: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        remainingPegs: 8,
        totalMoves: 12,
        durationSeconds: 45, // 00:45
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-008',
        date: DateTime.now().subtract(const Duration(days: 4)),
        remainingPegs: 3,
        totalMoves: 26,
        durationSeconds: 160, // 02:40
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-009',
        date: DateTime.now().subtract(const Duration(days: 5)),
        remainingPegs: 1,
        totalMoves: 33,
        durationSeconds: 195, // 03:15
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-010',
        date: DateTime.now().subtract(const Duration(days: 7)),
        remainingPegs: 5,
        totalMoves: 18,
        durationSeconds: 88, // 01:28
        isVictory: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peg Solitaire',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => const PegSolitaireScreen(),
        '/rules': (context) => const RulesScreen(),
        '/history': (context) =>
            HistoryScreen(records: _generateInitialHistory()),
      },
    );
  }
}
