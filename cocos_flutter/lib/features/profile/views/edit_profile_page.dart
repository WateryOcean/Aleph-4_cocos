import 'package:cocos_flutter/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/data/user_service.dart';

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

  String gender = 'Male';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Ambil dari AuthProvider (yang memiliki data terbaru)
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user != null) {
      setState(() {
        fullName.text = user.fullName;
        username.text = user.username;
        email.text = user.email;
        phone.text = user.phoneNumber;
        gender = user.gender;
      });
    } else {
      // Alternatif ke UserService jika AuthProvider belum siap
      await UserService.instance.loadFromPrefs();
      setState(() {
        fullName.text = UserService.instance.fullName;
        username.text = UserService.instance.username;
        email.text = UserService.instance.email;
        phone.text = UserService.instance.phone;
        gender = UserService.instance.gender;
      });
    }
  }

  Future<void> _saveData() async {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      // Alternatif: simpan hanya ke UserService jika tidak ada user yang login
      UserService.instance.setUser(
        fullName: fullName.text,
        username: username.text,
        email: email.text,
        phone: phone.text,
        gender: gender,
        profilePicture: UserService.instance.profilePicture,
      );
      await UserService.instance.saveToPrefs();
      if (mounted) Navigator.pop(context);
      return;
    }

    // Buat model user yang sudah diperbarui
    final updatedUser = currentUser.copyWith(
      fullName: fullName.text.trim(),
      username: username.text.trim(),
      email: email.text.trim(),
      phoneNumber: phone.text.trim(),
      gender: gender,
      // profilePicture tidak diubah (dapat diperbarui nanti)
    );

    // Simpan melalui AuthProvider (memperbarui Firestore + SharedPreferences + state lokal)
    await authProvider.updateUserProfile(updatedUser);

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    fullName.dispose();
    username.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
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
            'Edit Profile',
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
            _input(fullName, 'Full Name', Icons.person),
            _input(username, 'Username', Icons.alternate_email),
            _input(email, 'Email', Icons.email),
            _input(phone, 'Phone Number', Icons.phone),
            const SizedBox(height: 10),
            _genderSelector(),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPurple,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _saveData,
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white, fontSize: 14),
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
            onTap: () => setState(() => gender = 'Male'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: gender == 'Male'
                    ? AppColors.deepPurple
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.male,
                      color: gender == 'Male' ? Colors.white : Colors.white54),
                  const SizedBox(height: 4),
                  const Text('Male', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => gender = 'Female'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: gender == 'Female'
                    ? AppColors.deepPurple
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.female,
                      color: gender == 'Female' ? Colors.white : Colors.white54),
                  const SizedBox(height: 4),
                  const Text('Female', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}