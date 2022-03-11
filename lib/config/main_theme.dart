import 'package:flutter/material.dart';

class MainThemeData {
  static ThemeData themeData() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      primaryColor: _colorScheme.primary,
      iconTheme: IconThemeData(color: _colorScheme.primaryVariant),
      canvasColor: _colorScheme.background,
      scaffoldBackgroundColor: _colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: Color(0xff80deea),
      appBarTheme: AppBarTheme(
        color: _colorScheme.background,
        iconTheme: IconThemeData(color: _colorScheme.secondary),
      ),
      fontFamily: 'Balthazar',
    );
  }

  static const _colorScheme = ColorScheme(
    primary: Color(0xff3949ab),
    primaryVariant: Color(0xff00227b),
    secondary: Color(0xff607d8b),
    secondaryVariant: Color(0xff8eacbb),
    background: Color(0xff3949ab),
    surface: Colors.black12,
    onBackground: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    brightness: Brightness.dark,
  );
}
