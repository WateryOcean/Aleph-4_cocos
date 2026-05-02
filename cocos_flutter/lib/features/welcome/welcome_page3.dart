import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../routes/app_routes.dart';

class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});

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
                    Image.asset(
                      'assets/welcome_images/event_welcome.png',
                      height: 230,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.nunito(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: const [
                          TextSpan(text: 'Find Your Perfect \n'),
                          TextSpan(
                            text: 'Cosplay Costume',
                            style: TextStyle(color: Color(0xFF8B5CF6)),
                          ),
                        ],
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
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  Text(
                    'Step Into the Verse',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Find your perfect cosplay costume with our curated collection of designs. ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/logo_images/logo_cocosblack.png', height: 85),
                  const SizedBox(height: 46),
                  CustomButton(
                    text: 'START YOUR SHOPPING',
                    onPressed: () => AppRoutes.goToLogin(context),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => AppRoutes.goToSignIn(context),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.nunito(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: GoogleFonts.nunito(
                              fontWeight:
                                  FontWeight.bold, 
                              color: const Color(
                                0xFF8B5CF6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
