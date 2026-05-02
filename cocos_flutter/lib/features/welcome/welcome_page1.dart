import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen1 extends StatelessWidget {
  const WelcomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Half: Dark Slate
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: AppColors.mainBackground,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to,',
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('assets/logo_images/logo_cocos.png', height: 100),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Half: White Space
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Imagine, Customize, Cosplay!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cuztomizing is fun, and we\'re here to make it easy for you. Let\'s get started on your cosplay journey!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 70),
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
                          onPressed: () => AppRoutes.goToWelcome2(context),
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
