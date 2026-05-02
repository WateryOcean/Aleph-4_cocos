import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cart_dummy.dart';
import '../tile_widget/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = CartDummyData.dummyCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242830),
      
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                    children: const [
                      TextSpan(text: 'Your '),
                      TextSpan(text: 'Cart', style: TextStyle(color: Color(0xFFFF7675))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Review your selections before the next convention.', style: TextStyle(color: Colors.white38)),
                const SizedBox(height: 32),
                
                // List Items
                ...cart.items.asMap().entries.map((entry) {
                  return CartItemCard(
                    item: entry.value,
                    onRemove: () => setState(() => cart.items.removeAt(entry.key)),
                    onQuantityChanged: (val) => setState(() => entry.value.quantity = val),
                  );
                }),

                // Flash Deal Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFa29bfe)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                        child: const Text('FLASH DEAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Upgrade Your Gear', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Add a \'Kinetic Core\' for only \$19.99', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 200), // Space for bottom sheet
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildSummarySection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B23), // Background gelap sesuai referensi
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sisi Kiri: Info Total Harga
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total price',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Sisi Kanan: Tombol Checkout yang lonjong
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: const StadiumBorder(), 
                elevation: 0,
              ),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'Checkout',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}