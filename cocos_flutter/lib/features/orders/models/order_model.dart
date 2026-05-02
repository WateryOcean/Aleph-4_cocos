// lib/features/orders/models/order_model.dart
import 'package:flutter/material.dart';

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
  });

  OrderTimelineStep get currentStepData => kOrderTimeline[currentStep];
  bool get isCompleted => currentStep == kOrderTimeline.length - 1;
}
