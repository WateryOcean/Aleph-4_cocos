import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.navHeaderBackground,
      scaffoldBackgroundColor: AppColors.mainBackground,
      
      // Font Configuration dengan Google Fonts
      textTheme: GoogleFonts.nunitoTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      
      // Tema untuk AppBar, BottomNavigationBar, dan ElevatedButton
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navHeaderBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navHeaderBackground,
        selectedItemColor: AppColors.eventAccent,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navHeaderBackground,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
