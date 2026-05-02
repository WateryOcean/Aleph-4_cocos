// lib/features/cart/views/cart_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_navbar.dart';
import '../../../routes/app_routes.dart';
import '../data/cart_service.dart';
import '../tile_widget/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance.cart;
    final items = CartService.instance.items;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const CustomAppBar(title: 'My Cart', showBackButton: true),
      body: items.isEmpty ? _buildEmptyState() : _buildCartContent(items),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (items.isNotEmpty) _buildSummaryBar(cart.total),
          CustomNavBar(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
              if (index == 1) AppRoutes.goToEvents(context);
              if (index == 3) AppRoutes.goToProfile(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, color: Colors.white24, size: 80),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.nunito(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some costumes to get started!',
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
            label: Text(
              'Continue Shopping',
              style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(List items) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              children: const [
                TextSpan(text: 'Your '),
                TextSpan(text: 'Cart', style: TextStyle(color: AppColors.cartTheme)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your selections before the next convention.',
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Cart items
          ...CartService.instance.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return CartItemCard(
              item: item,
              onRemove: () => setState(() => CartService.instance.removeAt(index)),
              onQuantityChanged: (val) => setState(() => CartService.instance.updateQuantity(index, val)),
            );
          }),

          const SizedBox(height: 8),

          // Flash deal banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepPurple, Color(0xFFa29bfe)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'FLASH DEAL',
                    style: GoogleFonts.nunito(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Upgrade Your Gear',
                  style: GoogleFonts.nunito(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Add a 'Kinetic Core' for only \$19.99",
                  style: GoogleFonts.nunito(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total price',
                  style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.nunito(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              onPressed: () => AppRoutes.goToCheckout(context),
              child: Row(
                children: [
                  Text(
                    'Checkout',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
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
