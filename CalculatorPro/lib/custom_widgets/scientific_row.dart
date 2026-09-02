import 'package:flutter/material.dart';

class ScientificRow extends StatelessWidget {
  final bool isDarkMode;
  final Color accentColor;
  final void Function(String) onInsert;

  const ScientificRow({
    super.key,
    required this.isDarkMode,
    required this.accentColor,
    required this.onInsert,
  });

  static const _labels = [
    'sin(',
    'cos(',
    'tan(',
    '√',
    '(',
    ')',
    '!',
    'π',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _labels[index];
          return Material(
            color:
                isDarkMode ? const Color(0xFF232326) : const Color(0xFFEDF1F7),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onInsert(label == 'π' ? '3.14159265' : label),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  label,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
