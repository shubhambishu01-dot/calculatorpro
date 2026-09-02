import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_pro/provider/theme_provider.dart';
import 'package:calculator_pro/root_shell.dart';

void main() {
  runApp(const CalculatorProApp());
}

class CalculatorProApp extends StatelessWidget {
  const CalculatorProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'CalculatorPro',
            debugShowCheckedModeBanner: false,
            themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF3F4F6),
              colorScheme: ColorScheme.fromSeed(
                seedColor: theme.accentColor,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0E0E10),
              colorScheme: ColorScheme.fromSeed(
                seedColor: theme.accentColor,
                brightness: Brightness.dark,
              ),
            ),
            home: const RootShell(),
          );
        },
      ),
    );
  }
}
