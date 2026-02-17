import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  late Box _box;

  bool _autoSpeak = true;
  double _speechRate = 0.5;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isPremium = false;

  bool get autoSpeak => _autoSpeak;
  double get speechRate => _speechRate;
  ThemeMode get themeMode => _themeMode;
  bool get isPremium => _isPremium;

  SettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box('settingsBox');
    _loadSettings();
  }

  void _loadSettings() {
    _autoSpeak = _box.get('autoSpeak', defaultValue: true);
    _speechRate = _box.get('speechRate', defaultValue: 0.5);
    _themeMode =
        ThemeMode.values[_box.get('themeMode', defaultValue: 0)];
    _isPremium = _box.get('isPremium', defaultValue: false);

    notifyListeners();
  }

  Future<void> toggleAutoSpeak(bool val) async {
    _autoSpeak = val;
    await _box.put('autoSpeak', val);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _box.put('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _box.put('speechRate', rate);
    notifyListeners();
  }

  Future<void> setPremium(bool status) async {
    _isPremium = status;
    await _box.put('isPremium', status);
    notifyListeners();
  }
}
