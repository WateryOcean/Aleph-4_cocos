
import '../../cart/models/cart_model.dart';

class ShippingAddress {
  final String fullName;
  final String phoneNumber;
  final String addressLine;
  final String city;
  final String postalCode;

  ShippingAddress({
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine,
    required this.city,
    required this.postalCode,
  });
}

enum PaymentMethod {
  creditCard,
  bankTransfer,
  digitalWallet,
}

class OrderSummary {
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final ShippingAddress? address;
  final PaymentMethod? paymentMethod;

  OrderSummary({
    required this.items,
    required this.subtotal,
    this.shippingFee = 0.0,
    this.discount = 0.0,
    this.address,
    this.paymentMethod,
  });

  double get total => subtotal + shippingFee - discount;
}
