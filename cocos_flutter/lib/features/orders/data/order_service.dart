import '../../cart/models/cart_model.dart';
import '../../checkout/models/checkout_model.dart';
import '../models/order_model.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  final List<Order> _orders = [];
  OrderSummary? _lastCheckoutSummary;

  List<Order> get orders => List.unmodifiable(_orders);
  OrderSummary? get lastCheckoutSummary => _lastCheckoutSummary;

  List<Order> byCategory(OrderCategory category) =>
      _orders.where((o) => o.category == category).toList();

  void placeOrder({
    required List<CartItem> cartItems,
    required String name,
    required String phone,
    required String address,
    required String city,
    required String postal,
    required PaymentMethod paymentMethod,
  }) {
    final now = DateTime.now();
    final estimated = now.add(const Duration(days: 45));
    final orderNum =
        'CCS-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    for (var i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      final num = cartItems.length == 1 ? orderNum : '$orderNum-${i + 1}';

      _orders.add(Order(
        id: 'ord-new-${now.millisecondsSinceEpoch}-$i',
        orderNumber: num,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity,
        selectedSize: item.selectedSize,
        selectedMaterial: item.selectedMaterial,
        category: OrderCategory.packed,
        currentStep: 1,
        orderDate: now,
        estimatedDate: estimated,
      ));

      _orders.add(Order(
        id: 'ord-bill-${now.millisecondsSinceEpoch}-$i',
        orderNumber: num,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity,
        selectedSize: item.selectedSize,
        selectedMaterial: item.selectedMaterial,
        category: OrderCategory.bill,
        currentStep: 4,
        orderDate: now,
        estimatedDate: estimated,
      ));
    }

    _lastCheckoutSummary = OrderSummary(
      items: List.from(cartItems),
      subtotal: cartItems.fold(0, (sum, item) => sum + item.totalItemPrice),
      address: ShippingAddress(
        fullName: name,
        phoneNumber: phone,
        addressLine: address,
        city: city,
        postalCode: postal,
      ),
      paymentMethod: paymentMethod,
    );
  }
}
