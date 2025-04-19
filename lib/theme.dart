import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFFD9BB8A), // Arany
      scaffoldBackgroundColor: Colors.white, // Fehér háttér mindenhol
      canvasColor: Colors.white, // Általános háttérszín (pl. MaterialApp)
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey, // Alap színskála, de felülírjuk
        accentColor: const Color(0xFFD9BB8A),
        cardColor: Colors.white,
        errorColor: Colors.red,
      ).copyWith(
        primary: const Color(0xFFD9BB8A),
        surface: Colors.white, // Fehér felületek (pl. Scaffold, AppBar)
        onSurface: const Color(0xFF6A778A), // Szürke szöveg a felületeken
        surfaceTint:
            Colors.white, // Biztosítjuk, hogy a felületek ne legyenek szürkések
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor:
            Colors.white, // Biztosítjuk, hogy az AppBar ne legyen szürkés
        elevation: 4.0,
        iconTheme: IconThemeData(color: Color(0xFF6A778A)),
        titleTextStyle: TextStyle(
          color: Color(0xFF6A778A),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: GoogleFonts.openSansTextTheme().apply(
        bodyColor: const Color(0xFF6A778A),
        displayColor: const Color(0xFF6A778A),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFD9BB8A),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9BB8A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD9BB8A)),
        ),
      ),
    );
  }
}
