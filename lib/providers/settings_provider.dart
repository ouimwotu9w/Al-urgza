import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// إعدادات التطبيق: المظهر، حجم الخط، وخيارات القراءة.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs) {
    _themeMode = ThemeMode.values[_prefs.getInt('themeMode') ?? 0];
    _fontScale = _prefs.getDouble('fontScale') ?? 1.0;
    _showTashkeel = _prefs.getBool('showTashkeel') ?? true;
  }

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  double _fontScale = 1.0;
  bool _showTashkeel = true;

  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;
  bool get showTashkeel => _showTashkeel;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  void setFontScale(double value) {
    _fontScale = value;
    _prefs.setDouble('fontScale', value);
    notifyListeners();
  }

  void setShowTashkeel(bool value) {
    _showTashkeel = value;
    _prefs.setBool('showTashkeel', value);
    notifyListeners();
  }
}
