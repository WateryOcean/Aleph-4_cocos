// lib/features/orders/providers/order_provider.dart
import 'package:cocos_flutter/features/orders/data/order_repository.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../../cart/models/cart_model.dart';
import '../../checkout/models/checkout_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository.instance;
  final List<Order> _orders = [];
  bool _isProcessing = false;
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isProcessing => _isProcessing;
  bool get isLoading => _isLoading;

  // ─── CHECKOUT (Membuat Order) ────────────────────────────────────

  Future<void> checkoutCart({
    required String userId,
    required List<CartItem> cartItems,
    required PaymentMethod paymentMethod,
    required ShippingAddress shippingAddress,
  }) async {
    _isProcessing = true;
    notifyListeners();

    final now = DateTime.now();
    final estimated = now.add(const Duration(days: 45));
    final orderNum = 'CCS-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    try {
      for (var i = 0; i < cartItems.length; i++) {
        final item = cartItems[i];
        final uniqueNumber = cartItems.length == 1 ? orderNum : '$orderNum-${i + 1}';

        final newOrder = Order(
          id: 'ord-new-${now.millisecondsSinceEpoch}-$i',
          orderNumber: uniqueNumber,
          productName: item.productName,
          imageUrl: item.imageUrl,
          price: item.price,
          quantity: item.quantity,
          selectedSize: item.selectedSize,
          selectedMaterial: item.selectedMaterial,
          category: OrderCategory.packed,
          currentStep: 2,
          orderDate: now,
          estimatedDate: estimated,
          shippingAddress: shippingAddress,
          paymentMethod: paymentMethod,
        );

        await _orderRepository.saveOrder(newOrder, userId);
        _orders.add(newOrder);
      }
    } catch (e) {
      debugPrint('Gagal mengeksekusi pembuatan order checkout untuk $userId: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // ─── MUAT ORDER ────────────────────────────────────────────────

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loaded = await _orderRepository.loadOrders(userId);
      _orders.clear();
      _orders.addAll(loaded);
    } catch (e) {
      debugPrint('Failed to load orders for $userId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── PERBARUI LANGKAH ORDER (Kategori diperbarui otomatis) ──────────────────

  Future<void> updateOrderStep(String userId, String orderId, int newStep) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    final oldOrder = _orders[index];

    // Tentukan kategori baru berdasarkan langkah
    OrderCategory newCategory = oldOrder.category;

    // Jika mencapai langkah terakhir (indeks 4 = Delivered) → pindah ke "Shipped"
    if (newStep == kOrderTimeline.length - 1) {
      newCategory = OrderCategory.shipped;
    } else if (oldOrder.category == OrderCategory.shipped && newStep < kOrderTimeline.length - 1) {
      // Jika sebelumnya sudah shipped tapi kita mundur (debug), kembalikan ke packed
      newCategory = OrderCategory.packed;
    }

    final updatedOrder = Order(
      id: oldOrder.id,
      orderNumber: oldOrder.orderNumber,
      productName: oldOrder.productName,
      imageUrl: oldOrder.imageUrl,
      price: oldOrder.price,
      quantity: oldOrder.quantity,
      selectedSize: oldOrder.selectedSize,
      selectedMaterial: oldOrder.selectedMaterial,
      category: newCategory,
      currentStep: newStep,
      orderDate: oldOrder.orderDate,
      estimatedDate: oldOrder.estimatedDate,
      shippingAddress: oldOrder.shippingAddress,
      paymentMethod: oldOrder.paymentMethod,
    );

    _orders[index] = updatedOrder;
    notifyListeners();

    await _orderRepository.updateOrderStep(userId, orderId, newStep, newCategory);
    await loadOrders(userId);
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}