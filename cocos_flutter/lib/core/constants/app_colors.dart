import 'package:flutter/material.dart';

class AppColors {

  // === BASE COLORS (sesuai design kamu) ===
  static const Color darkSlate = Color(0xFF2F3640); // 50%
  static const Color deepPurple = Color(0xFF6C5CE7); // 20%
  static const Color vividOrange = Color(0xFFFF7675); // 15%
  static const Color softMint = Color(0xFF55E6C1); // 15%

  // === BACKGROUND ===
  static const Color mainBackground = darkSlate;
  static const Color navHeaderBackground = deepPurple;

  // === CARD & BORDER ===
  static const Color cardDark = Color(0xFF1E272E);
  static const Color border = Colors.white10;

  // === TEXT ===
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  // === ALIAS (biar kompatibel dengan code lama) ===
  static const Color primary = deepPurple;
  static const Color mint = softMint;
  static const Color orange = vividOrange;

  // === ACCENT ===
  static const Color eventAccent = vividOrange;
  static const Color cartTheme = vividOrange;

  // === BASIC ===
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF7F8C8D);
}