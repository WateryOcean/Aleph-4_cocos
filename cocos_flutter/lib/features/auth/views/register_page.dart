import 'package:cocos_flutter/core/utils/navigation_helper.dart';
import 'package:cocos_flutter/features/auth/data/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../widgets/auth_text_field.dart';
import '../../../core/widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _selectedProfilePath;
  String _gender = 'Male';

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_fullNameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Full name and email are required.',
              style: GoogleFonts.nunito(color: Colors.white)),
          backgroundColor: const Color(0xFF8B5CF6),
        ),
      );
      return;
    }

    UserService.instance.setUser(
      fullName: _fullNameCtrl.text.trim(),
      username: _usernameCtrl.text.trim().isEmpty
          ? '@${_fullNameCtrl.text.trim().replaceAll(' ', '_').toLowerCase()}'
          : _usernameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      gender: _gender,
      profilePicture: _selectedProfilePath ??
          'assets/logo_images/itachi_profile.png',
    );
    await UserService.instance.saveToPrefs();

    if (mounted) {
      AppNavigation.navigateWithLoading(context, AppRoutes.home);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Profile Picture',
              style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageOption('assets/logo_images/water_profile.jpg', 'Option 1'),
                _imageOption('assets/logo_images/itachi_profile.png', 'Option 2'),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _imageOption(String path, String label) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedProfilePath = path);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(path),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.nunito(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _genderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender',
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        Row(
          children: [
            _genderOption('Male', Icons.male),
            const SizedBox(width: 12),
            _genderOption('Female', Icons.female),
          ],
        ),
      ],
    );
  }

  Widget _genderOption(String value, IconData icon) {
    final selected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF8B5CF6)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF8B5CF6)
                  : Colors.black26,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? Colors.white : Colors.black54),
              const SizedBox(height: 4),
              Text(value,
                  style: GoogleFonts.nunito(
                      color: selected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
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
        title: Text('New Account',
            style: GoogleFonts.nunito(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // Profile picture picker
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: _selectedProfilePath != null
                        ? AssetImage(_selectedProfilePath!)
                        : null,
                    child: _selectedProfilePath == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePicker,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            AuthTextField(
              label: 'Full Name',
              hint: 'Aleph-4',
              icon: Icons.person_outline,
              controller: _fullNameCtrl,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: 'Username',
              hint: '@aleph_cos4er',
              icon: Icons.alternate_email,
              controller: _usernameCtrl,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: 'Date of Birth',
              hint: '01/07/2005',
              icon: Icons.calendar_today_outlined,
              controller: _dobCtrl,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: 'Email',
              hint: 'aleph@example.com',
              icon: Icons.email_outlined,
              controller: _emailCtrl,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: 'Phone Number',
              hint: '+1 234 567 890',
              icon: Icons.phone_android_outlined,
              controller: _phoneCtrl,
            ),
            const SizedBox(height: 20),

            AuthTextField(
              label: 'Country',
              hint: 'United States',
              icon: Icons.public,
              controller: _countryCtrl,
            ),
            const SizedBox(height: 20),

            _genderSelector(),
            const SizedBox(height: 48),

            CustomButton(
              text: 'Continue',
              color: const Color(0xFF8B5CF6),
              onPressed: _handleContinue,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
