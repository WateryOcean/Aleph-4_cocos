// lib/features/auth/views/signin_page.dart
import 'package:cocos_flutter/features/auth/data/auth_dummy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/navigation_helper.dart'; 
import '../../../core/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../widgets/auth_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSignIn() {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Debug: Sign in attempt
      // Available users in AuthDummyData

      // Check against dummy data
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.cartTheme,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Please fill in all fields.',
              style: GoogleFonts.nunito(color: AppColors.white),
            ),
          ),
        );
        return;
      }

      if (AuthDummyData.dummyUsers.containsKey(email)) {
        if (AuthDummyData.dummyUsers[email] == password) {
          // Credentials valid, navigating
          AppNavigation.navigateWithLoading(context, AppRoutes.home);
        } else {
          _showErrorSnackBar('Invalid password. Please try again.');
        }
      } else {
        _showErrorSnackBar('Email not found. Test credentials:\ncosplayer@example.com / password123\nadmin@cocos.com / admin2026\nguest@cocos.com / guestpass');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.cartTheme,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: GoogleFonts.nunito(color: AppColors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sign In',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In to Your Account',
              style: GoogleFonts.nunito(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back to the ultimate cosplay marketplace and community.',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),
            
            // Email Field
            AuthTextField(
              label: 'Email or username',
              hint: 'cosplayer@example.com',
              controller: _emailController,
            ),
            const SizedBox(height: 24),
            
            // Password Field
            AuthTextField(
              label: 'Password',
              hint: '••••••••',
              isPassword: true,
              controller: _passwordController,
            ),
            
            const SizedBox(height: 40),
            
            // Continue Button
            CustomButton(
              text: 'Continue',
              color: const Color(0xFF6C5CE7), // Your Deep Purple color
              onPressed: _handleSignIn, // Corrected: Just pass the function reference
            ),
          ],
        ),
      ),
    );
  }
}