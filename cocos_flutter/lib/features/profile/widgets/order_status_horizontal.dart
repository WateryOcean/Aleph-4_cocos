import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OrderStatusHorizontal extends StatelessWidget {
  const OrderStatusHorizontal({super.key});

  Widget item(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 20),

            item("Dikemas", Icons.inventory, AppColors.primary),
            const SizedBox(width: 25),

            item("Dikirim", Icons.local_shipping, AppColors.orange),
            const SizedBox(width: 25),

            item("Dibayar", Icons.payment, AppColors.primary),
            const SizedBox(width: 25),

            item("Voucher", Icons.card_giftcard, AppColors.mint),
            const SizedBox(width: 25),

            item("Belum Bayar", Icons.warning, Colors.redAccent),

            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}