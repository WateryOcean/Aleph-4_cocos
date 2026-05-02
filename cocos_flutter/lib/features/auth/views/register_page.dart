import 'package:cocos_flutter/core/utils/navigation_helper.dart';
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

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Profile Picture',
                style: GoogleFonts.nunito(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
        );
      },
    );
  }

  Widget _imageOption(String path, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProfilePath = path;
        });
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
          Text(
            label, 
            style: GoogleFonts.nunito(fontSize: 12, color: Colors.black54),
          ),
        ],
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
        title: Text(
          'New Account',
          style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
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
                        child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            const AuthTextField(
              label: 'Full Name',
              hint: 'Aleph-4',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Username',
              hint: '@aleph_cos4er',
              icon: Icons.alternate_email,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Date of Birth',
              hint: '01/07/2005',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Email',
              hint: 'aleph@example.com',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Phone Number',
              hint: '+1 234 567 890',
              icon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Country',
              hint: 'United States',
              icon: Icons.public,
            ),
            const SizedBox(height: 20),
            
            const AuthTextField(
              label: 'Gender',
              hint: 'Gender',
              icon: Icons.people_outline,
            ),
            const SizedBox(height: 48),
            
            CustomButton(
              text: 'Continue',
              color: const Color(0xFF8B5CF6),
              onPressed: () => AppNavigation.navigateWithLoading(context, AppRoutes.home),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
