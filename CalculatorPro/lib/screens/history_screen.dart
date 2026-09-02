import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/app_strings.dart';
import '../provider/theme_provider.dart';
import '../utils/preferences_service.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryEntry> history;
  final VoidCallback onClearAll;
  final void Function(HistoryEntry entry) onDeleteOne;
  final void Function(HistoryEntry entry) onReuse;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.onClearAll,
    required this.onDeleteOne,
    required this.onReuse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDarkMode = theme.isDarkMode;
    final strings = AppStrings(theme.language);
    final bg = isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFF3F4F6);
    final cardColor =
        isDarkMode ? const Color(0xFF1A1A1C) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1C1C1E);
    final subColor = isDarkMode ? Colors.white38 : Colors.black38;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      color: bg,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
              child: Row(
                children: [
                  Text(
                    strings.history,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  if (history.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      tooltip: strings.clearAll,
                      onPressed: () => _confirmClear(context, strings),
                    ),
                ],
              ),
            ),
            Expanded(
              child:
                  history.isEmpty
                      ? Center(
                        child: Text(
                          strings.noHistoryYet,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: subColor,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final entry = history[index];
                          return Dismissible(
                            key: ValueKey(
                              '${entry.timestamp.microsecondsSinceEpoch}-$index',
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => onDeleteOne(entry),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => onReuse(entry),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.expression,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: subColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '= ${entry.result}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        dateFormat.format(entry.timestamp),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, AppStrings strings) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(strings.clearHistory),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onClearAll();
                },
                child: Text(
                  strings.clearAll,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }
}
