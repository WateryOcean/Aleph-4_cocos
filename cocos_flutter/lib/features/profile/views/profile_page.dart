import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../routes/app_routes.dart';
import '../../orders/models/order_model.dart';
 
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
 
            // ── Profile Header ───────────────────────────────────────────
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
 
            const SizedBox(height: 28),
 
            // ── Order Status Section ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Orders',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _orderStatusButton(
                          context,
                          icon: Icons.payment_outlined,
                          label: 'Unpaid',
                          color: AppColors.vividOrange,
                          category: OrderCategory.unpaid,
                        ),
                        _dividerV(),
                        _orderStatusButton(
                          context,
                          icon: Icons.inventory_2_outlined,
                          label: 'Packed',
                          color: AppColors.primary,
                          category: OrderCategory.packed,
                        ),
                        _dividerV(),
                        _orderStatusButton(
                          context,
                          icon: Icons.local_shipping_outlined,
                          label: 'Shipped',
                          color: AppColors.softMint,
                          category: OrderCategory.shipped,
                        ),
                        _dividerV(),
                        _orderStatusButton(
                          context,
                          icon: Icons.receipt_long_outlined,
                          label: 'Bill',
                          color: AppColors.softMint,
                          category: OrderCategory.bill,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
 
            const SizedBox(height: 24),
 
            // ── Settings Card ────────────────────────────────────────────
            _settingsCard(),
 
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
 
  // ── Order status icon button ────────────────────────────────────────────
  Widget _orderStatusButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required OrderCategory category,
  }) {
    return GestureDetector(
      onTap: () => AppRoutes.goToOrderList(context, category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _dividerV() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
 
  // ── Settings Card ───────────────────────────────────────────────────────
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
 
  Widget _divider() => const Divider(color: Colors.white10, height: 1);
 
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
        if (title == "Edit Profile") {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          );
          _loadProfile();
        } else if (title == "Address") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddressPage()),
          );
        } else if (title == "Privacy Policy") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
          );
        } else if (title == "Help Center") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpCenterPage()),
          );
        } else if (title == "Logout") {
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
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child:
                const Text("Logout", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}