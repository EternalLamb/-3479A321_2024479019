import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class PreferencesService {
  //Definicion de variables para persistencia de sonido, vibración y puntaje
  final SharedPreferences _prefs;
  final Logger _logger = Logger();
  final _keySoundEnabled = 'sound_enabled';
  final _keyVibrationEnabled = 'vibration_enabled';
  final _keyBestScore = 'best_score';

  PreferencesService(this._prefs);
  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // CONFIGURACION INICIAL
  bool get isSoundEnabled => _prefs.getBool(_keySoundEnabled) ?? true;
  bool get isVibrationEnabled => _prefs.getBool(_keyVibrationEnabled) ?? true;
  int get bestRemainingPegs => _prefs.getInt(_keyBestScore) ?? 32;
  //Ejemplo de Set
  Future<bool> setSoundEnabled(bool enabled) async {
    _logger.i('PreferencesService: Sonido configurado en $enabled');
    return await _prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<void> checkAndSaveRecord(int remainingPegs) async {}
}
