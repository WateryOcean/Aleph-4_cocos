// lib/features/orders/models/order_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../checkout/models/checkout_model.dart';

enum OrderCategory { unpaid, packed, shipped, bill }

class OrderTimelineStep {
  final String label;
  final String description;
  final IconData icon;
  const OrderTimelineStep({
    required this.label,
    required this.description,
    required this.icon,
  });
}

const List<OrderTimelineStep> kOrderTimeline = [
  OrderTimelineStep(
    label: 'Awaiting Payment',
    description: 'Complete payment to start the costume production process.',
    icon: Icons.payment_outlined,
  ),
  OrderTimelineStep(
    label: 'Design Consultation',
    description: 'Our team will contact you to discuss costume details and design.',
    icon: Icons.design_services_outlined,
  ),
  OrderTimelineStep(
    label: 'In Production',
    description: 'Your costume is being carefully crafted by our artisans.',
    icon: Icons.precision_manufacturing_outlined,
  ),
  OrderTimelineStep(
    label: 'Quality Checking',
    description: 'Costume is quality checked and verified before shipment.',
    icon: Icons.fact_check_outlined,
  ),
  OrderTimelineStep(
    label: 'Delivered',
    description: 'Your costume is on its way to your address.',
    icon: Icons.local_shipping_outlined,
  ),
];

class Order {
  final String id;
  final String orderNumber;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;
  final String selectedSize;
  final String selectedMaterial;
  final OrderCategory category;
  final int currentStep;
  final DateTime orderDate;
  final DateTime estimatedDate;

  // Baru: field alamat dan metode pembayaran
  final ShippingAddress? shippingAddress;
  final PaymentMethod? paymentMethod;

  Order({
    required this.id,
    required this.orderNumber,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.selectedMaterial,
    required this.category,
    required this.currentStep,
    required this.orderDate,
    required this.estimatedDate,
    this.shippingAddress,
    this.paymentMethod,
  });

  OrderTimelineStep get currentStepData => kOrderTimeline[currentStep];
  bool get isCompleted => currentStep == kOrderTimeline.length - 1;

  // ─── Pembantu JSON ──────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'product_name': productName,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
      'selected_size': selectedSize,
      'selected_material': selectedMaterial,
      'category': category.name,
      'current_step': currentStep,
      'order_date': orderDate.toIso8601String(),
      'estimated_date': estimatedDate.toIso8601String(),
      if (shippingAddress != null) 'shipping_address': shippingAddress!.toJson(),
      if (paymentMethod != null) 'payment_method': paymentMethod!.name,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ?? '';
    final category = OrderCategory.values.firstWhere(
      (e) => e.name == categoryStr,
      orElse: () => OrderCategory.unpaid,
    );

    final rawShippingAddress = json['shipping_address'];
    final shippingAddress = rawShippingAddress == null
        ? null
        : ShippingAddress.fromJson(
            rawShippingAddress is String
                ? jsonDecode(rawShippingAddress) as Map<String, dynamic>
                : rawShippingAddress as Map<String, dynamic>,
          );

    PaymentMethod? paymentMethod;
    if (json['payment_method'] != null) {
      paymentMethod = PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.creditCard,
      );
    }

    return Order(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      productName: json['product_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedSize: json['selected_size'] ?? '',
      selectedMaterial: json['selected_material'] ?? '',
      category: category,
      currentStep: (json['current_step'] as num?)?.toInt() ?? 0,
      orderDate: DateTime.tryParse(json['order_date'] ?? '') ?? DateTime.now(),
      estimatedDate: DateTime.tryParse(json['estimated_date'] ?? '') ?? DateTime.now(),
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }
}