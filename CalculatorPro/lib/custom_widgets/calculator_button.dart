import 'package:flutter/material.dart';

enum CalcButtonKind { digit, operatorKey, control, equals, function }

class CalculatorButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isDarkMode;
  final CalcButtonKind kind;
  final Color accentColor;
  final double fontSize;

  const CalculatorButton({
    Key? key,
    required this.label,
    this.icon,
    required this.onPressed,
    required this.isDarkMode,
    this.kind = CalcButtonKind.digit,
    required this.accentColor,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    late final Color background;
    late final Color textColor;

    switch (widget.kind) {
      case CalcButtonKind.equals:
      case CalcButtonKind.operatorKey:
        background = widget.accentColor;
        textColor = Colors.white;
        break;
      case CalcButtonKind.control:
        background =
            isDarkMode ? const Color(0xFFAFAFAF) : const Color(0xFFD4D6DA);
        textColor = isDarkMode ? Colors.black : Colors.black87;
        break;
      case CalcButtonKind.function:
        background =
            isDarkMode ? const Color(0xFF2B2B2E) : const Color(0xFFEDF1F7);
        textColor = isDarkMode ? Colors.white70 : const Color(0xFF1C1C1E);
        break;
      case CalcButtonKind.digit:
        background =
            isDarkMode ? const Color(0xFF232326) : const Color(0xFFF7F7F7);
        textColor = isDarkMode ? Colors.white : const Color(0xFF1C1C1E);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color:
                _pressed
                    ? Color.alphaBlend(
                      Colors.white.withOpacity(0.12),
                      background,
                    )
                    : background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child:
              widget.icon ??
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
        ),
      ),
    );
  }
}
