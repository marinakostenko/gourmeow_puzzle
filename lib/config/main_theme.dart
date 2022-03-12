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
    primary: Color(0xff487487),
    primaryVariant: Color(0xff00227b),
    secondary: Color(0xffffeb3b),
    secondaryVariant: Color(0xffffff72),
    background: Color(0xff487487),
    surface: Colors.black12,
    onBackground: Color(0xffffeb3b),
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Color(0xff487487),
    brightness: Brightness.dark,
  );
}
