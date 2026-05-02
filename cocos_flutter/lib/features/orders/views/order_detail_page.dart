// lib/features/orders/views/order_detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
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

  String get _actionLabel {
    switch (order.category) {
      case OrderCategory.unpaid:
        return 'Pay Now';
      case OrderCategory.packed:
        return 'Support Center';
      case OrderCategory.shipped:
        return 'Track Package';
      case OrderCategory.bill:
        return 'View Bill';
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
                  // ── Product name & order number ─────────────────────────
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

                  // ── Info chips ──────────────────────────────────────────
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

                  // ── Timeline ────────────────────────────────────────────
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
      bottomSheet: _bottomAction(context),
    );
  }

  // ── Hero image with fade-to-background gradient ─────────────────────────
  Widget _buildHeroImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            order.imageUrl,
            fit: BoxFit.cover,
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

  // ── Small info chip ──────────────────────────────────────────────────────
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

  // ── One row in the vertical timeline ────────────────────────────────────
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
          // ── Left column: dot + connector line ───────────────────────────
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

          // ── Right column: label + description card ───────────────────────
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

  // Highlighted card for the active step
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

  // Plain label for done / pending steps
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

  // ── Sticky bottom action button ──────────────────────────────────────────
  Widget _bottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.mainBackground,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: CustomButton(
          text: _actionLabel,
          color: _accent,
          onPressed: () {},
        ),
      ),
    );
  }
}
