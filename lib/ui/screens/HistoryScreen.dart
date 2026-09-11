import 'package:flutter/material.dart';
import 'package:lab_moviles/models/GameRecord.dart';

class HistoryScreen extends StatelessWidget {
  final List<GameRecord> records;

  const HistoryScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Partidas'),
        centerTitle: true,
      ),
      body: records.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return _buildHistoryItem(context, record);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 64.0,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Sin historial de partidas',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, GameRecord record) {
    // Uso exclusivo de Theme.of(context)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Colores condicionales según el resultado de la partida
    final Color statusColor = record.isVictory
        ? colorScheme.primary
        : colorScheme.error;

    final Color containerColor = record.isVictory
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final Color onContainerColor = record.isVictory
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    // Formateo nativo de duración mm:ss
    final minutes = (record.durationSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (record.durationSeconds % 60).toString().padLeft(2, '0');
    final formattedDuration = '$minutes:$seconds';

    // Formateo nativo de fecha DD/MM/AAAA hh:mm
    final date = record.date;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final formattedDate = '$day/$month/$year $hour:$minute';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: containerColor,
          child: Icon(
            record.isVictory ? Icons.emoji_events : Icons.cancel_outlined,
            color: statusColor,
          ),
        ),
        title: Text(
          'ID: ${record.id}',
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Piezas restantes: ${record.remainingPegs} | Movimientos: ${record.totalMoves}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Tiempo: $formattedDuration • $formattedDate',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            record.isVictory ? 'Victoria' : 'Derrota',
            style: theme.textTheme.labelSmall?.copyWith(
              color: onContainerColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
