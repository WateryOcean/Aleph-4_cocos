import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/models/cart_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/models/order_model.dart';
import '../../orders/providers/order_provider.dart';
import '../models/checkout_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  // Controller untuk alamat pengiriman
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartProvider>().items;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const CustomAppBar(
        title: 'Checkout',
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
            CustomTextField(
              label: 'Recipient',
              hint: 'Enter recipient name',
              controller: _nameController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hint: '+xxx-xxx-xxxx',
              controller: _phoneController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Street Address',
              hint: 'Ex: 123 Cosplay St.',
              controller: _addressController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'City',
                    hint: 'Ex: Jakarta',
                    controller: _cityController,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    label: 'Postal Code',
                    hint: 'Ex: 12345',
                    controller: _postalController,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
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

            _buildOrderSummary(context, cartItems),
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
        color: AppColors.cartTheme,
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
                ? AppColors.cartTheme
                : const Color.fromARGB(26, 55, 51, 82),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.cartTheme : Colors.white60,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.cartTheme),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodLabel() {
    switch (_selectedMethod) {
      case PaymentMethod.creditCard:
        return 'Credit / Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.digitalWallet:
        return 'Digital Wallet';
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (_selectedMethod) {
      case PaymentMethod.creditCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_rounded;
      case PaymentMethod.digitalWallet:
        return Icons.account_balance_wallet_rounded;
    }
  }

  Widget _buildOrderSummary(BuildContext context, List<CartItem> items) {
    final cartProvider = context.watch<CartProvider>();
    final currentCart = cartProvider.cart;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Ringkasan Pesanan
          Text(
            'Order Summary',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.mainBackground,
            ),
          ),
          const Divider(height: 24),

          // Bagian Item Pesanan
          Text(
            'Items',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.productName}',
                        style: GoogleFonts.nunito(
                          color: const Color.fromARGB(221, 14, 14, 14),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(item.totalItemPrice),
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainBackground,
                      ),
                    ),
                  ],
                ),
              )),

          const Divider(height: 24),

          // Bagian Alamat Pengiriman
          Text(
            'Shipping Address',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cartTheme.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cartTheme.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.cartTheme, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      _nameController.text.isEmpty ? 'Not provided' : _nameController.text,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainBackground,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _addressController.text.isEmpty
                      ? 'Street address'
                      : _addressController.text,
                  style: GoogleFonts.nunito(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_cityController.text.isEmpty ? 'City' : _cityController.text}, ${_postalController.text.isEmpty ? 'Postal Code' : _postalController.text}',
                  style: GoogleFonts.nunito(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                if (_phoneController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppColors.cartTheme, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        _phoneController.text,
                        style: GoogleFonts.nunito(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bagian Metode Pembayaran
          Text(
            'Payment Method',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cartTheme.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cartTheme.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(_getPaymentMethodIcon(),
                    color: AppColors.cartTheme, size: 18),
                const SizedBox(width: 10),
                Text(
                  _getPaymentMethodLabel(),
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainBackground,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Ringkasan Harga
          _buildSummaryRow(
              'Subtotal', AppFormatters.formatCurrency(currentCart.subtotal)),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', 'FREE', isGreen: true),
          const SizedBox(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBackground)),
              Text(
                AppFormatters.formatCurrency(currentCart.total),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.cartTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Buat Pesanan
          CustomButton(
            text: 'PLACE ORDER',
            color: AppColors.cartTheme,
            textColor: Colors.white,
            onPressed: () async {
              final userId = context.read<AuthProvider>().user?.id ?? 'guest_user';
              final cartItems = List<CartItem>.from(context.read<CartProvider>().items);

              if (cartItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your cart is empty.')),
                );
                return;
              }

              // Susun alamat pengiriman dari form
              final shippingAddress = ShippingAddress(
                recipientName: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                addressLine: _addressController.text.trim(),
                city: _cityController.text.trim(),
                postalCode: _postalController.text.trim(),
              );

              // 1. Buat pesanan melalui OrderProvider dengan alamat dan pembayaran
              await context.read<OrderProvider>().checkoutCart(
                    userId: userId,
                    cartItems: cartItems,
                    paymentMethod: _selectedMethod,
                    shippingAddress: shippingAddress,
                  );

              // 2. Kosongkan keranjang melalui CartProvider
              await context.read<CartProvider>().clearCart(userId);

              // 3. Arahkan ke Daftar Pesanan (kategori Bill)
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.orderList,
                  (route) => route.settings.name == AppRoutes.home,
                  arguments: OrderCategory.bill,
                );
              }
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
            style: GoogleFonts.nunito(
              color: Colors.black54,
              fontSize: 14,
            )),
        Text(
          value,
          style: GoogleFonts.nunito(
            color: isGreen ? const Color(0xFF31B954) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}