// lib/features/orders/views/order_detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../checkout/models/checkout_model.dart';
import '../data/order_service.dart';
import '../models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  Color get _accent {
    switch (order.category) {
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

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('d MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const CustomAppBar(title: 'Order Details', showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName,
                    style: GoogleFonts.nunito(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order  #${order.orderNumber}',
                    style: GoogleFonts.nunito(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _infoChip(
                        Icons.calendar_today_outlined,
                        'Ordered',
                        dateFmt.format(order.orderDate),
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        Icons.schedule_outlined,
                        'Estimated',
                        dateFmt.format(order.estimatedDate),
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        Icons.payments_outlined,
                        'Total',
                        '\$${(order.price * order.quantity).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Order Status',
                    style: GoogleFonts.nunito(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Full transparency from payment until your costume arrives.',
                    style: GoogleFonts.nunito(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(
                    kOrderTimeline.length,
                    (i) => _timelineStep(i),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: order.category == OrderCategory.bill
          ? _bottomAction(context)
          : null,
    );
  }

  Widget _buildHeroImage() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            order.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, err, stack) => Container(
              color: AppColors.cardDark,
              child: const Icon(Icons.broken_image,
                  color: Colors.white24, size: 60),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.mainBackground],
                stops: [0.45, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accent, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineStep(int index) {
    final step = kOrderTimeline[index];
    final isDone = index < order.currentStep;
    final isCurrent = index == order.currentStep;
    final isPending = index > order.currentStep;
    final isLast = index == kOrderTimeline.length - 1;

    final Color dotColor = isDone
        ? AppColors.softMint
        : isCurrent
            ? _accent
            : Colors.white24;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: dotColor.withValues(alpha: isCurrent ? 0.18 : 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotColor,
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : step.icon,
                    color: dotColor,
                    size: 17,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.softMint.withValues(alpha: 0.35)
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: isCurrent
                  ? _currentStepCard(step)
                  : _plainStepLabel(step, isDone, isPending),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentStepCard(OrderTimelineStep step) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  step.label,
                  style: GoogleFonts.nunito(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Current',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            step.description,
            style: GoogleFonts.nunito(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _plainStepLabel(
      OrderTimelineStep step, bool isDone, bool isPending) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              step.label,
              style: GoogleFonts.nunito(
                color: isPending ? Colors.white30 : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          if (isDone)
            Text(
              '✓',
              style: GoogleFonts.nunito(
                color: AppColors.softMint,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.mainBackground,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'View Bill',
          color: _accent,
          onPressed: () => _showBillSheet(context),
        ),
      ),
    );
  }

  void _showBillSheet(BuildContext context) {
    var summaryForOrder = OrderService.instance.getSummaryForOrderId(order.id);
    final summary = summaryForOrder;
    final dateFmt = DateFormat('d MMM yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded,
                      color: AppColors.vividOrange, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Order Receipt',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Order #${order.orderNumber}',
                  style: GoogleFonts.nunito(
                      fontSize: 13, color: Colors.black45)),
              Text(dateFmt.format(order.orderDate),
                  style: GoogleFonts.nunito(
                      fontSize: 12, color: Colors.black38)),
              const Divider(height: 32),
              Text('Items',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  )),
              const SizedBox(height: 10),
              if (summary != null)
                ...summary.items.map((item) => _billItem(
                      '${item.quantity}x ${item.productName}',
                      AppFormatters.formatCurrency(item.totalItemPrice),
                    ))
              else
                _billItem(
                  '${order.quantity}x ${order.productName}',
                  AppFormatters.formatCurrency(order.price * order.quantity),
                ),
              const Divider(height: 28),
              _billRow(
                'Subtotal',
                AppFormatters.formatCurrency(
                    summary?.subtotal ?? order.price * order.quantity),
              ),
              const SizedBox(height: 8),
              _billRow('Shipping', 'FREE',
                  valueColor: const Color(0xFF31B954)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainBackground)),
                  Text(
                    AppFormatters.formatCurrency(
                        summary?.total ?? order.price * order.quantity),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.vividOrange,
                    ),
                  ),
                ],
              ),
              if (summary?.address != null) ...[
                const Divider(height: 32),
                Text('Shipping Address',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 8),
                _addressTile(summary!.address!),
              ],
              if (summary?.paymentMethod != null) ...[
                const SizedBox(height: 16),
                Text('Payment Method',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 8),
                _paymentTile(summary!.paymentMethod!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _billItem(String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.nunito(
                    color: AppColors.mainBackground, fontSize: 14)),
          ),
          Text(price,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainBackground)),
        ],
      ),
    );
  }

  Widget _billRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.nunito(color: Colors.black54, fontSize: 14)),
        Text(value,
            style: GoogleFonts.nunito(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _addressTile(ShippingAddress addr) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.vividOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.vividOrange.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(addr.fullName.isEmpty ? '—' : addr.fullName,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainBackground,
                  fontSize: 13)),
          if (addr.addressLine.isNotEmpty)
            Text(addr.addressLine,
                style:
                    GoogleFonts.nunito(color: Colors.black54, fontSize: 12)),
          if (addr.city.isNotEmpty || addr.postalCode.isNotEmpty)
            Text('${addr.city}, ${addr.postalCode}',
                style:
                    GoogleFonts.nunito(color: Colors.black54, fontSize: 12)),
          if (addr.phoneNumber.isNotEmpty)
            Text(addr.phoneNumber,
                style:
                    GoogleFonts.nunito(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _paymentTile(PaymentMethod method) {
    final (IconData icon, String label) = switch (method) {
      PaymentMethod.creditCard =>
        (Icons.credit_card_rounded, 'Credit / Debit Card'),
      PaymentMethod.bankTransfer =>
        (Icons.account_balance_rounded, 'Bank Transfer'),
      PaymentMethod.digitalWallet =>
        (Icons.account_balance_wallet_rounded, 'Digital Wallet'),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.vividOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.vividOrange.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.vividOrange, size: 18),
          const SizedBox(width: 10),
          Text(label,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainBackground,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
