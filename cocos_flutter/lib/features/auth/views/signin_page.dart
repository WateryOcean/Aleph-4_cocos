import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 1. Aksi untuk Login menggunakan Email & Password (Firebase Authentication)
  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final bool success = await authProvider.signIn(email, password);

    if (success) {
      if (mounted) {
        AppNavigation.navigateWithLoading(context, AppRoutes.home);
      }
    } else {
      _showSnackBar('Email or password is incorrect. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.cartTheme,
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: GoogleFonts.nunito(color: AppColors.white)),
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
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: isLoading ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Sign In',
          style: GoogleFonts.nunito(
              color: Colors.black, fontWeight: FontWeight.bold),
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
                  color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back to the ultimate cosplay marketplace and community.',
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 48),
            AuthTextField(
              label: 'Email',
              hint: 'cosplayer@example.com',
              controller: _emailController,
            ),
            const SizedBox(height: 24),
            AuthTextField(
              label: 'Password',
              hint: '••••••••',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 40),

            isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C5CE7)))
                : CustomButton(
                    text: 'Continue',
                    color: const Color(0xFF6C5CE7),
                    onPressed: _handleSignIn,
                  ),
          ],
        ),
      ),
    );
  }
}