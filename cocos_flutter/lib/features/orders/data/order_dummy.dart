// lib/features/orders/data/order_dummy.dart
import '../models/order_model.dart';

class OrderDummyData {
  static final List<Order> orders = [
    // ── UNPAID ──────────────────────────────────────────────────────────────
    Order(
      id: 'ord-001',
      orderNumber: 'CCS-20241101',
      productName: 'One Piece Set',
      imageUrl: 'assets/product_images/anime_images/onepiece_images/set_onepiece.png',
      price: 299.00,
      quantity: 1,
      selectedSize: 'M',
      selectedMaterial: 'Premium Fabric',
      category: OrderCategory.unpaid,
      currentStep: 0,
      orderDate: DateTime(2024, 11, 1),
      estimatedDate: DateTime(2024, 12, 15),
    ),
    Order(
      id: 'ord-002',
      orderNumber: 'CCS-20241105',
      productName: 'Genshin Impact Set',
      imageUrl: 'assets/product_images/game_images/genshin_images/set_genshin.png',
      price: 350.00,
      quantity: 1,
      selectedSize: 'L',
      selectedMaterial: 'EVA Foam',
      category: OrderCategory.unpaid,
      currentStep: 0,
      orderDate: DateTime(2024, 11, 5),
      estimatedDate: DateTime(2024, 12, 20),
    ),

    // ── PACKED (in design consultation or production) ─────────────────────
    Order(
      id: 'ord-003',
      orderNumber: 'CCS-20241010',
      productName: 'Demon Slayer Set',
      imageUrl: 'assets/product_images/anime_images/demonslayer_images/set_demonslayer.png',
      price: 249.00,
      quantity: 1,
      selectedSize: 'M',
      selectedMaterial: 'Premium EVA Foam',
      category: OrderCategory.packed,
      currentStep: 1,
      orderDate: DateTime(2024, 10, 10),
      estimatedDate: DateTime(2024, 11, 25),
    ),
    Order(
      id: 'ord-004',
      orderNumber: 'CCS-20240925',
      productName: 'Elden Ring Set',
      imageUrl: 'assets/product_images/game_images/eldenring_images/set_eldenring.png',
      price: 420.00,
      quantity: 1,
      selectedSize: 'XL',
      selectedMaterial: 'Thermoplastic',
      category: OrderCategory.packed,
      currentStep: 2,
      orderDate: DateTime(2024, 9, 25),
      estimatedDate: DateTime(2024, 11, 10),
    ),

    // ── SHIPPED (quality check or in transit) ────────────────────────────
    Order(
      id: 'ord-005',
      orderNumber: 'CCS-20240820',
      productName: 'Harry Potter Set',
      imageUrl: 'assets/product_images/film_images/harrypott_images/set_harrypott.png',
      price: 189.00,
      quantity: 1,
      selectedSize: 'S',
      selectedMaterial: 'Standard Fabric',
      category: OrderCategory.shipped,
      currentStep: 3,
      orderDate: DateTime(2024, 8, 20),
      estimatedDate: DateTime(2024, 10, 5),
    ),
    Order(
      id: 'ord-006',
      orderNumber: 'CCS-20240715',
      productName: 'Star Wars Set',
      imageUrl: 'assets/product_images/film_images/starwars_images/set_starwars.png',
      price: 399.00,
      quantity: 1,
      selectedSize: 'M',
      selectedMaterial: 'Worbla + Foam',
      category: OrderCategory.shipped,
      currentStep: 4,
      orderDate: DateTime(2024, 7, 15),
      estimatedDate: DateTime(2024, 9, 1),
    ),

    // ── BILL (completed, awaiting invoice review) ─────────────────────────
    Order(
      id: 'ord-007',
      orderNumber: 'CCS-20240601',
      productName: 'One Piece Set',
      imageUrl: 'assets/product_images/anime_images/onepiece_images/set_onepiece.png',
      price: 299.00,
      quantity: 2,
      selectedSize: 'M',
      selectedMaterial: 'Premium Fabric',
      category: OrderCategory.bill,
      currentStep: 4,
      orderDate: DateTime(2024, 6, 1),
      estimatedDate: DateTime(2024, 7, 15),
    ),
    Order(
      id: 'ord-008',
      orderNumber: 'CCS-20240510',
      productName: 'Genshin Impact Set',
      imageUrl: 'assets/product_images/game_images/genshin_images/set_genshin.png',
      price: 350.00,
      quantity: 1,
      selectedSize: 'S',
      selectedMaterial: 'EVA Foam',
      category: OrderCategory.bill,
      currentStep: 4,
      orderDate: DateTime(2024, 5, 10),
      estimatedDate: DateTime(2024, 6, 25),
    ),
  ];

  static List<Order> byCategory(OrderCategory category) =>
      orders.where((o) => o.category == category).toList();
}
