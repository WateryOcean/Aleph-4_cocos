// lib/features/orders/views/order_list_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_navbar.dart';
import '../../../routes/app_routes.dart';
import '../data/order_dummy.dart';
import '../models/order_model.dart';

class OrderListPage extends StatelessWidget {
  final OrderCategory category;
  const OrderListPage({super.key, required this.category});

  String get _title {
    switch (category) {
      case OrderCategory.unpaid:
        return 'Unpaid';
      case OrderCategory.packed:
        return 'Packed';
      case OrderCategory.shipped:
        return 'Sent';
      case OrderCategory.bill:
        return 'Bill';
    }
  }

  Color get _accentColor {
    switch (category) {
      case OrderCategory.unpaid:
        return AppColors.vividOrange;
      case OrderCategory.packed:
        return AppColors.primary;
      case OrderCategory.shipped:
        return AppColors.primary;
      case OrderCategory.bill:
        return AppColors.softMint;
    }
  }

  IconData get _headerIcon {
    switch (category) {
      case OrderCategory.unpaid:
        return Icons.payment_outlined;
      case OrderCategory.packed:
        return Icons.inventory_2_outlined;
      case OrderCategory.shipped:
        return Icons.local_shipping_outlined;
      case OrderCategory.bill:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderDummyData.byCategory(category);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: CustomAppBar(title: _title, showBackButton: true),
      body: orders.isEmpty ? _buildEmptyState() : _buildList(context, orders),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (r) => false);
          }
          if (index == 1) AppRoutes.goToEvents(context);
          if (index == 2) AppRoutes.goToCart(context);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_headerIcon, size: 72, color: _accentColor.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          Text(
            'No Orders',
            style: GoogleFonts.nunito(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No orders with status "$_title".',
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(context, orders[index]),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final dateStr = DateFormat('d MMM yyyy').format(order.orderDate);

    return GestureDetector(
      onTap: () => AppRoutes.goToOrderDetail(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            // ── Product info row ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      order.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, err, stack) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.white10,
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.white24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productName,
                          style: GoogleFonts.nunito(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.orderNumber}  ·  $dateStr',
                          style: GoogleFonts.nunito(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${order.selectedSize}  ·  ${order.selectedMaterial}',
                          style: GoogleFonts.nunito(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\$${order.price.toStringAsFixed(2)}',
                          style: GoogleFonts.nunito(
                            color: _accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress mini-bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (order.currentStep + 1) / kOrderTimeline.length,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                  minHeight: 3,
                ),
              ),
            ),
            const SizedBox(height: 2),

            // ── Status footer ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.08),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(order.currentStepData.icon,
                      color: _accentColor, size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.currentStepData.label,
                      style: GoogleFonts.nunito(
                        color: _accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Step ${order.currentStep + 1} / ${kOrderTimeline.length}',
                    style: GoogleFonts.nunito(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white38, size: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
