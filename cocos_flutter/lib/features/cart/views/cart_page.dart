// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Cart',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: items.isEmpty ? _buildEmptyState() : _buildCartContent(items),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (items.isNotEmpty) _buildSummaryBar(cart.total),
          CustomNavBar(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) AppRoutes.loginSuccess(context);
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
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some costumes to get started!',
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => AppRoutes.loginSuccess(context),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.cartTheme),
            label: Text(
              'Continue Shopping',
              style: GoogleFonts.nunito(color: AppColors.cartTheme, fontWeight: FontWeight.bold),
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
              style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
              children: const [
                TextSpan(text: 'Your '),
                TextSpan(text: 'Cart', style: TextStyle(color: AppColors.cartTheme)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your selections before the next convention.',
            style: GoogleFonts.nunito(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Cart items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return CartItemCard(
              item: item,
              onRemove: () => setState(() => CartService.instance.removeAt(index)),
              onQuantityChanged: (val) => setState(() => CartService.instance.updateQuantity(index, val)),
            );
          }),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
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
                  'Total Price',
                  style: GoogleFonts.nunito(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.nunito(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cartTheme,
                foregroundColor: AppColors.white,
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
