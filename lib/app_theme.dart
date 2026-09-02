import 'package:flutter/material.dart';

class AppTheme {
  static const Color primarySeed = Color.fromARGB(
    255,
    62,
    228,
    239,
  ); // Un color de Ejemplo.

  static const Color boardBaseColor = Color.fromARGB(
    255,
    8,
    226,
    92,
  ); // Un color de Ejemplo.
  static const Color emptyHoleColor = Color.fromARGB(
    255,
    0,
    0,
    0,
  ); // Un color de Ejemplo.

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeed,
        brightness: Brightness.light,
        surfaceContainerHighest: const Color.fromARGB(255, 245, 242, 235),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F2EB),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primarySeed,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.bold, //SUMAREMOS nuestra fuente en la siguiente línea.
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
