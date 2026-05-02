import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../cart/data/cart_dummy.dart';
import '../../orders/models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../models/checkout_model.dart';
 
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
 
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}
 
class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  final cart = CartDummyData.dummyCart;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3640),
      appBar: const CustomAppBar(
        title: 'COCOS',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Secure Checkout',
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
 
            _buildSectionHeader('1. Shipping Address'),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Username', hint: 'xxxxx'),
            const SizedBox(height: 16),
            const CustomTextField(
                label: 'Phone Number', hint: '+62 822 - 7788 - 2343'),
            const SizedBox(height: 16),
            const CustomTextField(
                label: 'Street Address', hint: '123 Cosplay Lane'),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                    child: CustomTextField(label: 'City', hint: 'Neo Tokyo')),
                SizedBox(width: 12),
                Expanded(
                    child: CustomTextField(
                        label: 'Postal Code', hint: '10101')),
              ],
            ),
 
            const SizedBox(height: 32),
 
            _buildSectionHeader('2. Payment Method'),
            const SizedBox(height: 16),
            _buildPaymentOption(
              PaymentMethod.creditCard,
              'Credit / Debit Card',
              Icons.credit_card_rounded,
            ),
            _buildPaymentOption(
              PaymentMethod.bankTransfer,
              'Bank Transfer',
              Icons.account_balance_rounded,
            ),
            _buildPaymentOption(
              PaymentMethod.digitalWallet,
              'Digital Wallet',
              Icons.account_balance_wallet_rounded,
            ),
 
            const SizedBox(height: 32),
 
            _buildOrderSummary(context),
          ],
        ),
      ),
    );
  }
 
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 135, 125, 211),
      ),
    );
  }
 
  Widget _buildPaymentOption(
      PaymentMethod method, String label, IconData icon) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C5CE7)
                : const Color.fromARGB(26, 55, 51, 82),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color.fromARGB(255, 186, 184, 201)
                  : Colors.white60,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF6C5CE7)),
          ],
        ),
      ),
    );
  }
 
  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 18, 18, 18),
            ),
          ),
          const Divider(height: 32),
 
          ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.productName}',
                        style: GoogleFonts.nunito(
                            color: const Color.fromARGB(221, 14, 14, 14)),
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(item.totalItemPrice),
                      style:
                          GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
 
          const Divider(height: 32),
          _buildSummaryRow(
              'Subtotal', AppFormatters.formatCurrency(cart.subtotal)),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', 'FREE', isGreen: true),
          const SizedBox(height: 24),
 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold)),
              Text(
                AppFormatters.formatCurrency(cart.total),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 21, 21, 21),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
 
          CustomButton(
            text: 'PLACE ORDER',
            color: const Color(0xFF6C5CE7),
            textColor: Colors.white,
            onPressed: () {
              // Navigate to Unpaid orders, clearing checkout from stack
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.orderList,
                (route) => route.settings.name == AppRoutes.home,
                arguments: OrderCategory.unpaid,
              );
            },
          ),
        ],
      ),
    );
  }
 
  Widget _buildSummaryRow(String label, String value,
      {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.nunito(color: Colors.black54)),
        Text(
          value,
          style: GoogleFonts.nunito(
            color: isGreen
                ? const Color.fromARGB(255, 31, 32, 32)
                : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}