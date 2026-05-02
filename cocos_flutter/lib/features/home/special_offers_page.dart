// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_navbar.dart';
import '../../../routes/app_routes.dart';

class SpecialOffersPage extends StatefulWidget {
  const SpecialOffersPage({super.key});

  @override
  State<SpecialOffersPage> createState() => _SpecialOffersPageState();
}

class _SpecialOffersPageState extends State<SpecialOffersPage> {
  final int _currentIndex = 0;
  
  final List<Map<String, String>> _offers = [
    {
      'name': 'Weekend Warrior Flash Sale',
      'desc': 'Complete armor set bodysuit and accessories for your next Medieval adventure. Premium materials and DIY friendly.',
      'time': 'Ends in 2 days',
      'image': 'assets/offer_images/offer_1.png',
    },
    {
      'name': 'Acme Armor Sets',
      'desc': 'Buy one premium armor set, in a 15% off flash sale. Perfect for last-minute convention prep or upgrading your current cosplay with high-quality materials.',
      'time': 'Ends in 24 hours',
      'image': 'assets/offer_images/offer_2.png',
    },
    {
      'name': 'Fantasy Wig Collection',
      'desc': 'Exclusive heat-resistant wig styles in custom gradients. Limited stock available for high-tier professional cosplayers. Buy free for the 3rd purchase!',
      'time': 'Ends in 5 hours',
      'image': 'assets/offer_images/offer_3.png',
    },
    {
      'name': 'Accessory Madness',
      'desc': 'All accessories 20% off! From intricate jewelry to prop weapons, complete your cosplay with our wide range of high-quality accessories.',
      'time': 'Ends in 8 days',
      'image': 'assets/offer_images/offer_4.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const CustomAppBar(
        title: 'Special Offers',
        showBackButton: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _offers.length,
        itemBuilder: (context, index) {
          final offer = _offers[index];
          return _buildOfferCard(
            name: offer['name']!,
            desc: offer['desc']!,
            time: offer['time']!,
            imagePath: offer['image']!,
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _navigateToPage(index);
        },
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
        break;
      case 1:
        // Already on special offers page
        break;
      case 3:
        // Navigator.pushNamed(context, '/cart');
        break;
      case 4:
        // Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  Widget _buildOfferCard({
    required String name,
    required String desc,
    required String time,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offer Image
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                // --- INSERT OFFER IMAGE PATH BELOW ---
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF55E6C1), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: const Color(0xFF55E6C1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
