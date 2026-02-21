import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'screens/splash_gate.dart';
import 'theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final int _defaultThemeIndex = () {
    final index = appThemeOptions.indexWhere((t) => t.name == 'Dark Solaris');
    return index >= 0 ? index : 0;
  }();

  int _themeIndex = _defaultThemeIndex;
  bool _darkMode = true;

  void _setThemeIndex(int index) {
    if (_themeIndex == index) {
      return;
    }
    setState(() {
      _themeIndex = index;
    });
  }

  void _setDarkMode(bool value) {
    if (_darkMode == value) {
      return;
    }
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = appThemeOptions[_themeIndex];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game of Life',
      theme: selectedTheme.buildThemeData(darkMode: false),
      darkTheme: selectedTheme.buildThemeData(darkMode: true),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashGate(
        child: AppShell(
          selectedTheme: selectedTheme,
          selectedThemeIndex: _themeIndex,
          darkMode: _darkMode,
          onThemeChanged: _setThemeIndex,
          onDarkModeChanged: _setDarkMode,
        ),
      ),
    );
  }
}
