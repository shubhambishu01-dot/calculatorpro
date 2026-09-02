import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The 3 selectable accent themes shown on the Settings screen,
/// matching "Classic", "Malva Rose" and "Electric Blue".
enum AppAccent { classic, malvaRose, electricBlue }

/// Supported in-app languages. Full translation coverage is limited to the
/// core screens (Calculator, Tools hub, History, Settings); the rest of the
/// app falls back to English.
enum AppLanguage { english, hindi }

class AppAccentData {
  final String label;
  final Color primary;
  final Color secondary;
  final Color tertiary;

  const AppAccentData({
    required this.label,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

const Map<AppAccent, AppAccentData> kAccents = {
  AppAccent.classic: AppAccentData(
    label: 'Classic',
    primary: Color(0xFFFF8A00),
    secondary: Color(0xFF1C1C1E),
    tertiary: Color(0xFFB0B0B0),
  ),
  AppAccent.malvaRose: AppAccentData(
    label: 'Malva Rose',
    primary: Color(0xFFE8779A),
    secondary: Color(0xFF1C1C1E),
    tertiary: Color(0xFF8E86C9),
  ),
  AppAccent.electricBlue: AppAccentData(
    label: 'Electric Blue',
    primary: Color(0xFF1E9BFF),
    secondary: Color(0xFF1C1C1E),
    tertiary: Color(0xFF5C6C8C),
  ),
};

class ThemeProvider extends ChangeNotifier {
  static const _darkModeKey = 'darkMode';
  static const _accentKey = 'accentTheme';
  static const _languageKey = 'appLanguage';
  static const _decimalPlacesKey = 'decimalPlaces'; // -1 = automatic
  static const _thousandsSepKey = 'thousandsSeparator'; // ',' '.' ' ' ''

  bool _isDarkMode = true;
  AppAccent _accent = AppAccent.classic;
  AppLanguage _language = AppLanguage.english;
  int _decimalPlaces = -1; // -1 = automatic
  String _thousandsSeparator = ',';

  bool get isDarkMode => _isDarkMode;
  AppAccent get accent => _accent;
  AppAccentData get accentData => kAccents[_accent]!;
  Color get accentColor => accentData.primary;
  AppLanguage get language => _language;
  int get decimalPlaces => _decimalPlaces;
  String get thousandsSeparator => _thousandsSeparator;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? true;
    final accentIndex = prefs.getInt(_accentKey) ?? 0;
    _accent =
        AppAccent.values[accentIndex.clamp(0, AppAccent.values.length - 1)];
    final langIndex = prefs.getInt(_languageKey) ?? 0;
    _language = AppLanguage.values[langIndex.clamp(
      0,
      AppLanguage.values.length - 1,
    )];
    _decimalPlaces = prefs.getInt(_decimalPlacesKey) ?? -1;
    _thousandsSeparator = prefs.getString(_thousandsSepKey) ?? ',';
    notifyListeners();
  }

  void updateTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _persist();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _persist();
  }

  void setAccent(AppAccent accent) {
    _accent = accent;
    notifyListeners();
    _persist();
  }

  void setLanguage(AppLanguage language) {
    _language = language;
    notifyListeners();
    _persist();
  }

  void setDecimalPlaces(int value) {
    _decimalPlaces = value;
    notifyListeners();
    _persist();
  }

  void setThousandsSeparator(String value) {
    _thousandsSeparator = value;
    notifyListeners();
    _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    await prefs.setInt(_accentKey, _accent.index);
    await prefs.setInt(_languageKey, _language.index);
    await prefs.setInt(_decimalPlacesKey, _decimalPlaces);
    await prefs.setString(_thousandsSepKey, _thousandsSeparator);
  }

  /// Formats a raw numeric string (e.g. "1234.5") according to the current
  /// decimal-places and thousands-separator settings.
  String formatNumber(String raw) {
    final value = double.tryParse(raw);
    if (value == null) return raw;

    String numberStr;
    if (_decimalPlaces < 0) {
      // Automatic: trim trailing zeros, keep up to 6 decimals.
      numberStr = value.toStringAsFixed(6);
      numberStr = numberStr.replaceFirst(RegExp(r'0+$'), '');
      numberStr = numberStr.replaceFirst(RegExp(r'\.$'), '');
    } else {
      numberStr = value.toStringAsFixed(_decimalPlaces);
    }

    final isNegative = numberStr.startsWith('-');
    if (isNegative) numberStr = numberStr.substring(1);

    final parts = numberStr.split('.');
    String intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    if (_thousandsSeparator.isNotEmpty) {
      final buffer = StringBuffer();
      for (int i = 0; i < intPart.length; i++) {
        if (i != 0 && (intPart.length - i) % 3 == 0) {
          buffer.write(_thousandsSeparator);
        }
        buffer.write(intPart[i]);
      }
      intPart = buffer.toString();
    }

    final result = decPart.isNotEmpty ? '$intPart.$decPart' : intPart;
    return isNegative ? '-$result' : result;
  }
}
