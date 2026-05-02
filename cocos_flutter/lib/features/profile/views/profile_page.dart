import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';

import 'edit_profile_page.dart';
import 'address_page.dart';
import 'privacy_policy_page.dart';
import 'help_center_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "Andrew Ainsley";
  String username = "@Andrew";
  String gender = "Male";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString("fullName") ?? "Andrew Ainsley";
      username = prefs.getString("username") ?? "@Andrew";
      gender = prefs.getString("gender") ?? "Male";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const CustomAppBar(title: "Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// PROFILE HEADER
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/logo_images/itachi_profile.png'),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gender == "Male" ? Icons.male : Icons.female,
                      color: gender == "Male"
                          ? AppColors.softMint
                          : AppColors.vividOrange,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      fullName,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                Text(
                  username,
                  style: GoogleFonts.nunito(color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _orderIcons(),

            const SizedBox(height: 24),

            _settingsCard(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= ORDER =================
  Widget _orderIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _icon(Icons.payment, "Unpaid"),
        _icon(Icons.inventory_2, "Packed"),
        _icon(Icons.local_shipping, "Shipped"),
        _icon(Icons.receipt, "Bill"),
      ],
    );
  }

  Widget _icon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.softMint.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.softMint),
        ),
        const SizedBox(height: 6),
        Text(text, style: GoogleFonts.nunito(color: Colors.white70)),
      ],
    );
  }

  // ================= SETTINGS =================
  Widget _settingsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _item(Icons.person, "Edit Profile"),
          _divider(),
          _item(Icons.location_on, "Address"),
          _divider(),
          _item(Icons.security, "Privacy Policy"),
          _divider(),
          _item(Icons.help, "Help Center"),
          _divider(),
          _item(Icons.logout, "Logout", isLogout: true),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(color: Colors.white10, height: 1);
  }

  Widget _item(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : AppColors.softMint,
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          color: isLogout ? Colors.redAccent : Colors.white,
        ),
      ),
      trailing: isLogout
          ? null
          : const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.white30),
      onTap: () async {

        /// 🔥 FIX SEMUA ROUTING
        if (title == "Edit Profile") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfilePage(),
            ),
          );
          _loadProfile();
        }

        else if (title == "Address") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddressPage(),
            ),
          );
        }

        else if (title == "Privacy Policy") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PrivacyPolicyPage(),
            ),
          );
        }

        else if (title == "Help Center") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HelpCenterPage(),
            ),
          );
        }

        else if (title == "Logout") {
          _logoutDialog();
        }
      },
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text("Logout"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement logout logic
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
