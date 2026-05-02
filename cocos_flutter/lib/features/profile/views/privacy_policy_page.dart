import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSlate,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "Privacy Policy",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _title("1. Types of Data We Collect"),
            const SizedBox(height: 10),
            _desc(
              "We collect different types of data to provide and improve our services. "
              "This includes personal information such as your name, email address, and phone number, "
              "as well as usage data like interactions within the app, preferences, and activity logs.",
            ),

            const SizedBox(height: 24),

            _title("2. Use of Your Personal Data"),
            const SizedBox(height: 10),
            _desc(
              "Your personal data is used to enhance user experience, process transactions, "
              "and provide personalized recommendations. We may also use your data for communication purposes, "
              "such as sending updates, notifications, and important service information.",
            ),

            const SizedBox(height: 24),

            _title("3. Disclosure of Your Personal Data"),
            const SizedBox(height: 10),
            _desc(
              "We value your privacy and do not share your personal data without your consent. "
              "However, your data may be shared with trusted third parties for essential operations such as "
              "payment processing and delivery services, or when required by law.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
  }

  Widget _desc(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        height: 1.6,
        color: Colors.white70,
      ),
    );
  }
}