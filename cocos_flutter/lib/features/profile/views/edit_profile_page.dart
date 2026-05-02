import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String gender = "Male";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName.text = prefs.getString("fullName") ?? "";
      username.text = prefs.getString("username") ?? "";
      email.text = prefs.getString("email") ?? "";
      phone.text = prefs.getString("phone") ?? "";
      gender = prefs.getString("gender") ?? "Male";
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("fullName", fullName.text);
    await prefs.setString("username", username.text);
    await prefs.setString("email", email.text);
    await prefs.setString("phone", phone.text);
    await prefs.setString("gender", gender);

    Navigator.pop(context);
  }

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
            "Edit Profile",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input(fullName, "Full Name", Icons.person),
            _input(username, "Username", Icons.alternate_email),
            _input(email, "Email", Icons.email),
            _input(phone, "Phone Number", Icons.phone),

            const SizedBox(height: 10),

            _genderSelector(),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPurple,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _saveData,
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.nunito(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = "Male"),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: gender == "Male"
                    ? AppColors.deepPurple
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.male,
                      color: gender == "Male"
                          ? Colors.white
                          : Colors.white54),
                  const SizedBox(height: 4),
                  const Text("Male", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = "Female"),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: gender == "Female"
                    ? AppColors.deepPurple
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.female,
                      color: gender == "Female"
                          ? Colors.white
                          : Colors.white54),
                  const SizedBox(height: 4),
                  const Text("Female", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}