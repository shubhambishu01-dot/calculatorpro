import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorEngine {
  /// Evaluates a calculator expression and returns a clean, trimmed
  /// decimal string, or null if the expression is invalid.
  String? evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return null;
    try {
      String cleaned = _handleCustomFunctions(expression);
      cleaned = _autoCloseParens(cleaned);
      final Parser parser = Parser();
      final Expression exp = parser.parse(cleaned);
      final ContextModel cm = ContextModel();
      final double eval = exp.evaluate(EvaluationType.REAL, cm);
      if (eval.isNaN || eval.isInfinite) return null;
      return _trim(eval);
    } catch (_) {
      return null;
    }
  }

  String _trim(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toStringAsFixed(0);
    }
    String s = value.toStringAsFixed(8);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  String _autoCloseParens(String expression) {
    final open = '('.allMatches(expression).length;
    final close = ')'.allMatches(expression).length;
    if (open > close) {
      return expression + ')' * (open - close);
    }
    return expression;
  }

  String _handleCustomFunctions(String expression) {
    // Percent: turn "N%" into "(N/100)". Applied first so a trailing
    // percent sign on the whole expression also resolves correctly.
    expression = expression.replaceAllMapped(
      RegExp(r'(\d+(\.\d+)?)%'),
      (m) => '(${m[1]}/100)',
    );

    expression = expression.replaceAllMapped(RegExp(r'sin\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.sin(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'cos\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.cos(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'tan\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.tan(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'(\d+)!'), (m) {
      final val = int.tryParse(m[1]!) ?? 0;
      return _factorial(val).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'√(\d+(\.\d+)?)'), (m) {
      return 'sqrt(${m[1]})';
    });

    return expression;
  }

  int _factorial(int n) => (n <= 1) ? 1 : n * _factorial(n - 1);
  double _degToRad(double deg) => deg * math.pi / 180;
}
