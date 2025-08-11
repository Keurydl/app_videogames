import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clase que contiene los temas de la aplicación
class AppTheme {
  // Colores principales
  static const Color azulClaro = Color(0xFFE9F1FA);
  static const Color azulBrillante = Color(0xFF00ABE4);
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFB00020);

  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: azulBrillante,
    colorScheme: ColorScheme.light(
      primary: azulBrillante,
      secondary: azulClaro,
      background: azulClaro,
      surface: blanco,
    ),
    scaffoldBackgroundColor: azulClaro,
    appBarTheme: AppBarTheme(
      backgroundColor: azulBrillante,
      foregroundColor: blanco,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: blanco,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
    textTheme: GoogleFonts.robotoTextTheme(),
    cardTheme: CardThemeData(
      color: blanco,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: azulBrillante,
      foregroundColor: blanco,
    ),
  );

  // Tema oscuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: Color(0xFF121212),
      background: Color(0xFF121212),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      elevation: 2,
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
