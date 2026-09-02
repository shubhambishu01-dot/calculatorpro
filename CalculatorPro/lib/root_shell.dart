import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/top_nav_bar.dart';
import 'provider/theme_provider.dart';
import 'screens/calculator_home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'unit_converter.dart';
import 'utils/preferences_service.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final PreferencesService _preferencesService = PreferencesService();

  int _selectedTab = 0;
  List<HistoryEntry> _history = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _preferencesService.getHistory();
    if (!mounted) return;
    setState(() {
      _history = history;
      _loaded = true;
    });
  }

  void _onNewHistoryEntry(HistoryEntry entry) {
    setState(() {
      _history.insert(0, entry);
    });
    _preferencesService.setHistory(_history);
  }

  void _onDeleteOne(HistoryEntry entry) {
    setState(() {
      _history.remove(entry);
    });
    _preferencesService.setHistory(_history);
  }

  void _onClearAll() {
    setState(() {
      _history.clear();
    });
    _preferencesService.clearHistory();
  }

  void _reuseFromHistory(HistoryEntry entry) {
    setState(() => _selectedTab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDarkMode = theme.isDarkMode;
    final bg = isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFF3F4F6);

    if (!_loaded) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: CircularProgressIndicator(color: theme.accentColor),
        ),
      );
    }

    final pages = <Widget>[
      CalculatorHomeScreen(onNewHistoryEntry: _onNewHistoryEntry),
      const UnitConverter(),
      HistoryScreen(
        history: _history,
        onClearAll: _onClearAll,
        onDeleteOne: _onDeleteOne,
        onReuse: _reuseFromHistory,
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: TopNavBar(
        selectedIndex: _selectedTab,
        isDarkMode: isDarkMode,
        accentColor: theme.accentColor,
        onSelect: (index) => setState(() => _selectedTab = index),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: KeyedSubtree(
          key: ValueKey(_selectedTab),
          child: pages[_selectedTab],
        ),
      ),
    );
  }
}
