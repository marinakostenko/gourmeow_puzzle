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
    );
  }

  static const _colorScheme = ColorScheme(
    primary: Color(0xff263238),
    primaryVariant: Color(0xff4f5b62),
    secondary: Color(0xffbf360c),
    secondaryVariant: Color(0xff870000),
    background: Color(0xff263238),
    surface: Colors.black12,
    onBackground: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    brightness: Brightness.dark,
  );
}
