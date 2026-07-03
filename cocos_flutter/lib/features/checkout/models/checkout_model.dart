// lib/features/checkout/models/checkout_model.dart
import '../../cart/models/cart_model.dart';

class ShippingAddress {
  final String recipientName;
  final String phoneNumber;
  final String addressLine;
  final String city;
  final String postalCode;

  ShippingAddress({
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine,
    required this.city,
    required this.postalCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'address_line': addressLine,
      'city': city,
      'postal_code': postalCode,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      recipientName: json['recipient_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      addressLine: json['address_line'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }
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