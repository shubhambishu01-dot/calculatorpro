import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;
  final bool isDarkMode;
  final bool showResultPreview;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
    required this.isDarkMode,
    this.showResultPreview = true,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = isDarkMode ? Colors.white : const Color(0xFF1C1C1E);
    final subColor = isDarkMode ? Colors.white60 : Colors.black45;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              expression.isEmpty ? '' : expression,
              maxLines: 1,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: subColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              result,
              maxLines: 1,
              style: TextStyle(
                fontSize: 58,
                fontWeight: FontWeight.w600,
                color: mainColor,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
