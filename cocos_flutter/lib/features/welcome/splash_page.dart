import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer for 5 seconds then navigate to Welcome Page 1
    Timer(const Duration(seconds: 5), () {
      AppRoutes.goToWelcome1(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_images/logo_cocos.png', 
              width: 300,
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'FREEDOM IN COSPLAY',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: Text(
                'CUSTOM COSPLAY COSTUME SHOP',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}