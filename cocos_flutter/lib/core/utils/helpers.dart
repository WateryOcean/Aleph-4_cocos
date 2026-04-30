import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHelpers {
  // Snackbar feedback
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF6C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Helper navigasi
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Validasi email
  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  // Unfocus keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}