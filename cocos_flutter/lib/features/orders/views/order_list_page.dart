import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_navbar.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrderListPage extends StatefulWidget {
  final OrderCategory category;
  const OrderListPage({super.key, required this.category});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  String _currentUserId = '';
  bool _isLoadingCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil ID pengguna saat ini dari AuthProvider
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.id ?? 'guest_user';

    // Hanya muat jika ID pengguna berubah atau belum pernah dimuat
    if (_currentUserId != userId || !_isLoadingCalled) {
      _currentUserId = userId;
      _isLoadingCalled = true;
      // Muat order setelah frame selesai dibangun untuk menghindari masalah
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrderProvider>().loadOrders(userId);
        }
      });
    }
  }

  String get _title {
    switch (widget.category) {
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
    switch (widget.category) {
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
    switch (widget.category) {
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
    final orderProvider = context.watch<OrderProvider>();
    final orders = widget.category == OrderCategory.bill
        ? orderProvider.orders.where((o) => o.category != OrderCategory.unpaid).toList()
        : orderProvider.orders.where((o) => o.category == widget.category).toList();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: CustomAppBar(title: _title, showBackButton: true),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? _buildEmptyState()
              : _buildList(context, orders),
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
    return widget.category == OrderCategory.bill
        ? _buildBillOrderCard(context, order)
        : _buildStandardOrderCard(context, order);
  }

  Widget _buildStandardOrderCard(BuildContext context, Order order) {
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
            // Baris info produk
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

            // Mini-bar progres
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

            // Footer status
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillOrderCard(BuildContext context, Order order) {
    final dateStr = DateFormat('d MMM yyyy').format(order.orderDate);
    final total = order.price * order.quantity;

    return GestureDetector(
      onTap: () => AppRoutes.goToOrderDetail(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white10,
                    image: DecorationImage(
                      image: AssetImage(order.imageUrl),
                      fit: BoxFit.cover,
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
                      const SizedBox(height: 6),
                      Text(
                        order.orderNumber,
                        style: GoogleFonts.nunito(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: GoogleFonts.nunito(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.softMint.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'BILL',
                    style: GoogleFonts.nunito(
                      color: AppColors.softMint,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBillRow('Item', '${order.quantity}x ${order.productName}'),
            const SizedBox(height: 8),
            _buildBillRow('Size / Material', '${order.selectedSize} · ${order.selectedMaterial}'),
            const SizedBox(height: 8),
            _buildBillRow('Price', AppFormatters.formatCurrency(order.price)),
            const SizedBox(height: 8),
            _buildBillRow('Total', AppFormatters.formatCurrency(total), isTotal: true),
            const SizedBox(height: 8),
            _buildBillRow('Shipping', 'FREE', valueColor: const Color(0xFF31B954)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total',
                  style: GoogleFonts.nunito(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AppFormatters.formatCurrency(total),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.vividOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: AppColors.textSecondary,
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
