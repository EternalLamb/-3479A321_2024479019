import 'package:audioplayers/audioplayers.dart';
import 'package:lab_moviles/Applogger.dart'; // Ajusta la ruta según tu estructura

class AudioService {
  static final AudioService instance = AudioService._internal();
  late final AudioPlayer _player;
  bool _isInitialized = false;
  AudioService._internal() {
    _player = AudioPlayer();
    _configurePlayer();
  }
  Future<void> _configurePlayer() async {
    try {
      // Optimización: Modo de baja latencia para respuestas acústicas inmediatas
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);
      _isInitialized = true;
      AppLogger.info('AudioService inicializado en modo Low Latency');
    } catch (e) {
      AppLogger.error('Fallo en la inicialización del AudioService: $e');
    }
  }

  Future<void> playSelect() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('PATH'));
    } catch (e) {
      AppLogger.error('No se pudo reproducir NAME.mp3: $e');
    }
  }

  Future<void> playJump() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('PATH'));
      AppLogger.info('Reproduciendo NAME.mp3 con éxito');
    } catch (e) {
      AppLogger.error('No se pudo reproducir NAME.mp3: $e');
    }
  }

  Future<void> playGameOver() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('PATH'));
    } catch (e) {
      AppLogger.error('No se pudo reproducir NAME.mp3: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
