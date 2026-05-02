// lib/features/cart/data/cart_service.dart
import '../models/cart_model.dart';
import '../../product/models/product_model.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  Cart get cart => Cart(items: _items);
  bool get isEmpty => _items.isEmpty;

  void addProduct(
    ProductModel product, {
    required String size,
    required String material,
  }) {
    final index = _items.indexWhere(
      (item) =>
          item.id == product.id &&
          item.selectedSize == size &&
          item.selectedMaterial == material,
    );
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(
        id: product.id,
        productName: product.name,
        imageUrl: product.imagePath,
        price: product.price,
        selectedSize: size,
        selectedMaterial: material,
      ));
    }
  }

  void removeAt(int index) => _items.removeAt(index);

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity = quantity;
    }
  }
}
