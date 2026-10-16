import 'package:audioplayers/audioplayers.dart';
import 'package:lab_moviles/Applogger.dart';

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
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);
      _isInitialized = true;
      AppLogger.info('AudioService inicializado en modo Low Latency');
    } catch (e) {
      AppLogger.error('Fallo en la inicialización del AudioService: $e');
    }
  }

  // Ninguno de estos métodos debe recibir parámetros entre los paréntesis
  Future<void> playSelect() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('audio/Select.mp3'));
    } catch (e) {
      AppLogger.warning('No se pudo reproducir selection.mp3: $e');
    }
  }

  Future<void> playJump() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('audio/Move.mp3'));
      await _player.setVolume(3.0);
    } catch (e) {
      AppLogger.warning('No se pudo reproducir move.mp3: $e');
    }
  }

  Future<void> playGameOver() async {
    if (!_isInitialized) return;
    try {
      await _player.play(AssetSource('audio/End.mp3'));
    } catch (e) {
      AppLogger.warning('No se pudo reproducir final.mp3: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
