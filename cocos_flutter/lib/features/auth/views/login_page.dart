import 'package:cocos_flutter/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_images/logo_cocos.png', height: 120),
              const SizedBox(height: 40),
              Text(
                'Login to Your Account',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () => AppNavigation.navigateWithLoading(context, AppRoutes.home),
                icon: Image.asset('assets/logo_images/google_logo.png', height: 20),
                label: Text('Continue with Google', style: GoogleFonts.nunito(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: GoogleFonts.nunito(color: Colors.grey)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Sign In',
                color: const Color(0xFF8B5CF6),
                onPressed: () => AppRoutes.goToSignIn(context),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => AppRoutes.goToSignUp(context),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.nunito(color: AppColors.black),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 97, 80, 231),
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
    );
  }
}