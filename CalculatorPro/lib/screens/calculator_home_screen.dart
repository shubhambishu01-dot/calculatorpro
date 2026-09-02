import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/calculator_buttons.dart';
import '../custom_widgets/calculator_display.dart';
import '../custom_widgets/scientific_row.dart';
import '../provider/theme_provider.dart';
import '../utils/calculator_engine.dart';
import '../utils/preferences_service.dart';

class CalculatorHomeScreen extends StatefulWidget {
  final void Function(HistoryEntry entry) onNewHistoryEntry;

  const CalculatorHomeScreen({super.key, required this.onNewHistoryEntry});

  @override
  State<CalculatorHomeScreen> createState() => _CalculatorHomeScreenState();
}

class _CalculatorHomeScreenState extends State<CalculatorHomeScreen> {
  final CalculatorEngine _engine = CalculatorEngine();

  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;
  bool _showScientific = false;

  static const _operators = {'+', '-', '*', '/'};

  void _onDigit(String value) {
    setState(() {
      if (_justEvaluated) {
        _expression = '';
        _justEvaluated = false;
      }
      // Avoid multiple leading zeros like "00"
      if (value == '0' && _expression == '0') return;
      if (_expression == '0' && value != '.') {
        _expression = value;
      } else {
        _expression += value;
      }
      _updatePreview();
    });
  }

  void _onOperator(String op) {
    setState(() {
      _justEvaluated = false;
      if (_expression.isEmpty) {
        if (op == '-') {
          _expression = '-';
        }
        return;
      }
      final last = _expression[_expression.length - 1];
      if (_operators.contains(last)) {
        _expression = _expression.substring(0, _expression.length - 1) + op;
      } else {
        _expression += op;
      }
      _updatePreview();
    });
  }

  void _onPercent() {
    setState(() {
      if (_expression.isEmpty) return;
      _expression += '%';
      _updatePreview();
    });
  }

  void _onClear() {
    setState(() {
      _expression = '';
      _result = '0';
      _justEvaluated = false;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      _updatePreview();
    });
  }

  void _onToggleSign() {
    setState(() {
      if (_expression.isEmpty) return;
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
      _updatePreview();
    });
  }

  void _onInsertFunction(String value) {
    setState(() {
      if (_justEvaluated) {
        _expression = '';
        _justEvaluated = false;
      }
      _expression += value;
      _updatePreview();
    });
  }

  void _updatePreview() {
    final preview = _engine.evaluateExpression(_expression);
    _result = preview ?? (_expression.isEmpty ? '0' : _result);
  }

  void _evaluate() {
    if (_expression.isEmpty) return;
    final evalResult = _engine.evaluateExpression(_expression);
    setState(() {
      if (evalResult != null) {
        final entry = HistoryEntry(
          expression: _expression,
          result: evalResult,
          timestamp: DateTime.now(),
        );
        widget.onNewHistoryEntry(entry);
        _result = evalResult;
        _expression = evalResult;
        _justEvaluated = true;
      } else {
        _result = 'Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDarkMode = theme.isDarkMode;
    final accent = theme.accentColor;
    final bg = isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFF3F4F6);
    final displayResult =
        _result == 'Error' ? _result : theme.formatNumber(_result);

    return Container(
      color: bg,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: IconButton(
                        icon: Icon(
                          Icons.functions,
                          size: 20,
                          color:
                              _showScientific
                                  ? accent
                                  : (isDarkMode
                                      ? Colors.white38
                                      : Colors.black38),
                        ),
                        tooltip: 'Scientific functions',
                        onPressed:
                            () => setState(
                              () => _showScientific = !_showScientific,
                            ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CalculatorDisplay(
                    expression: _expression,
                    result: displayResult,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  if (_showScientific)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ScientificRow(
                        isDarkMode: isDarkMode,
                        accentColor: accent,
                        onInsert: _onInsertFunction,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                  left: 4,
                  right: 4,
                ),
                child: CalculatorButtons(
                  isDarkMode: isDarkMode,
                  accentColor: accent,
                  onDigit: _onDigit,
                  onOperator: _onOperator,
                  onClear: _onClear,
                  onBackspace: _onBackspace,
                  onToggleSign: _onToggleSign,
                  onPercent: _onPercent,
                  onEvaluate: _evaluate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
