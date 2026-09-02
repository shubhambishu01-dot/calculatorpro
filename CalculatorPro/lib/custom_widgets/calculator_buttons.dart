import 'package:flutter/material.dart';

import 'calculator_button.dart';

class CalculatorButtons extends StatelessWidget {
  final void Function(String) onDigit;
  final void Function(String) onOperator;
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onToggleSign;
  final VoidCallback onPercent;
  final VoidCallback onEvaluate;
  final bool isDarkMode;
  final Color accentColor;

  const CalculatorButtons({
    super.key,
    required this.onDigit,
    required this.onOperator,
    required this.onClear,
    required this.onBackspace,
    required this.onToggleSign,
    required this.onPercent,
    required this.onEvaluate,
    required this.isDarkMode,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _row([
              _btn(
                'C',
                CalcButtonKind.control,
                onClear,
                fontSize: 22,
              ),
              _btn(
                '±',
                CalcButtonKind.control,
                onToggleSign,
                fontSize: 24,
              ),
              _iconBtn(
                Icons.backspace_outlined,
                CalcButtonKind.control,
                onBackspace,
              ),
              _btn('÷', CalcButtonKind.operatorKey, () => onOperator('/')),
            ]),
            _row([
              _btn('7', CalcButtonKind.digit, () => onDigit('7')),
              _btn('8', CalcButtonKind.digit, () => onDigit('8')),
              _btn('9', CalcButtonKind.digit, () => onDigit('9')),
              _btn('×', CalcButtonKind.operatorKey, () => onOperator('*')),
            ]),
            _row([
              _btn('4', CalcButtonKind.digit, () => onDigit('4')),
              _btn('5', CalcButtonKind.digit, () => onDigit('5')),
              _btn('6', CalcButtonKind.digit, () => onDigit('6')),
              _btn('−', CalcButtonKind.operatorKey, () => onOperator('-')),
            ]),
            _row([
              _btn('1', CalcButtonKind.digit, () => onDigit('1')),
              _btn('2', CalcButtonKind.digit, () => onDigit('2')),
              _btn('3', CalcButtonKind.digit, () => onDigit('3')),
              _btn('+', CalcButtonKind.operatorKey, () => onOperator('+')),
            ]),
            _row([
              _btn('%', CalcButtonKind.digit, onPercent, fontSize: 22),
              _btn('0', CalcButtonKind.digit, () => onDigit('0')),
              _btn('.', CalcButtonKind.digit, () => onDigit('.')),
              _btn('=', CalcButtonKind.equals, onEvaluate),
            ]),
          ],
          );
      },
    );
  }

  Widget _row(List<Widget> children) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _btn(
    String label,
    CalcButtonKind kind,
    VoidCallback onTap, {
    double fontSize = 26,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = (constraints.maxWidth - 12).clamp(
            0.0,
            constraints.maxHeight,
          );
            return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CalculatorButton(
                label: label,
                kind: kind,
                onPressed: onTap,
                isDarkMode: isDarkMode,
                accentColor: accentColor,
                fontSize: fontSize,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconBtn(IconData icon, CalcButtonKind kind, VoidCallback onTap) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = (constraints.maxWidth - 12).clamp(
            0.0,
            constraints.maxHeight,
          );
            return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CalculatorButton(
                label: '',
                icon: Icon(
                  icon,
                  color: isDarkMode ? Colors.black : Colors.black87,
                  size: 22,
                ),
                kind: kind,
                onPressed: onTap,
                isDarkMode: isDarkMode,
                accentColor: accentColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
