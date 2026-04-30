import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: GoogleFonts.nunito(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(),
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}