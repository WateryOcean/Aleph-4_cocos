import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconUrl;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.network(iconUrl, height: 24),
      label: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        side: const BorderSide(color: Colors.black12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}