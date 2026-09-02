import 'package:shared_preferences/shared_preferences.dart';

/// One saved calculation: the expression, the result, and when it happened.
class HistoryEntry {
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryEntry({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  // Serialized as "expression@@result@@millisSinceEpoch" so it can be
  // stored in a plain SharedPreferences string list.
  static const _sep = '@@';

  String serialize() =>
      '$expression$_sep$result$_sep${timestamp.millisecondsSinceEpoch}';

  static HistoryEntry? tryParse(String raw) {
    final parts = raw.split(_sep);
    if (parts.length != 3) return null;
    final millis = int.tryParse(parts[2]);
    if (millis == null) return null;
    return HistoryEntry(
      expression: parts[0],
      result: parts[1],
      timestamp: DateTime.fromMillisecondsSinceEpoch(millis),
    );
  }
}

class PreferencesService {
  static const _darkModeKey = 'darkMode';
  static const _historyKey = 'calc_history_v2';

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? true;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map(HistoryEntry.tryParse)
        .whereType<HistoryEntry>()
        .toList();
  }

  Future<void> setHistory(List<HistoryEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    // Cap history at 200 entries so shared_preferences stays small.
    final capped = history.take(200).toList();
    await prefs.setStringList(
      _historyKey,
      capped.map((e) => e.serialize()).toList(),
    );
  }

  Future<void> addEntry(HistoryEntry entry) async {
    final current = await getHistory();
    current.insert(0, entry);
    await setHistory(current);
  }

  Future<void> clearHistory() async {
    await setHistory([]);
  }
}
