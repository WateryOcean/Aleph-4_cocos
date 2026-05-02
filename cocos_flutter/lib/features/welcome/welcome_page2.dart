import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Half: Dark Slate
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: AppColors.mainBackground,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/welcome_images/shop_welcome.png', height: 220),
                    const SizedBox(height: 24),
                    Text(
                      'Custom Shopping',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFFC084FC),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Half: White Space
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'You can customize what you buy?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Customize your cosplay costume with our easy-to-use online tool. Choose your design, materials, and details to create a one-of-a-kind outfit that\'s uniquely you!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  SizedBox(height: 85),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          text: 'Skip',
                          onPressed: () => AppRoutes.goToLogin(context),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                        ),
                      ),

                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          text: 'Next',
                          onPressed: () => AppRoutes.goToWelcome3(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
