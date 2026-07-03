import 'package:cocos_flutter/features/product/models/product_model.dart';
import 'package:flutter/material.dart';
import '../data/cart_repository.dart';
import '../models/cart_model.dart';
 
class CartProvider extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository.instance;
  List<CartItem> _items = [];
  bool _isLoading = false;
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  Cart get cart => Cart(items: _items);
 
  //Memuat data keranjang belanja secara dinamis berdasarkan userId dari UI
  Future<void> loadCartItems(String userId) async {
    _isLoading = true;
    notifyListeners();
 
    try {
      // Mengambil daftar item dari database lokal SQLite berdasarkan userId aktif
      _items = await _cartRepository.getCartItems(userId);
    } catch (e) {
      debugPrint('Gagal memuat item keranjang untuk $userId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
 
  //Menambah produk ke dalam keranjang secara dinamis berdasarkan userId dari UI
  Future<void> addItem(String userId, ProductModel product, String size, String material) async {
    final index = _items.indexWhere(
      (item) => item.id == product.id && item.selectedSize == size && item.selectedMaterial == material,
    );
 
    CartItem targetItem;
 
    if (index >= 0) {
      _items[index].quantity++;
      targetItem = _items[index];

    } else {
      targetItem = CartItem(
        id: product.id,
        productName: product.name,
        imageUrl: product.imagePath,
        price: product.price,
        quantity: 1,
        selectedSize: size,
        selectedMaterial: material,
      );
      _items.add(targetItem);
    }
 
    notifyListeners();
    await _cartRepository.addToCart(targetItem, userId);
    await loadCartItems(userId);
  }

  // Menghapus satu item dari keranjang
  Future<void> removeItem(String userId, String itemId) async {
    // 1. Hapus dari list lokal (UI langsung berubah)
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();

    // 2. Hapus dari repository (SQLite + Firestore)
    await _cartRepository.removeCartItem(userId, itemId);

    // 3. Reload untuk konsistensi (opsional)
    await loadCartItems(userId);
  }

  // Mengubah quantity item di keranjang
  Future<void> updateQuantity(String userId, String itemId, int newQuantity) async {
    // 1. Cari item di list lokal
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    // 2. Update quantity di list lokal
    _items[index].quantity = newQuantity;
    notifyListeners();

    // 3. Update di repository (SQLite + Firestore)
    await _cartRepository.updateCartItemQuantity(userId, itemId, newQuantity);

    // 4. Reload untuk konsistensi (opsional)
    await loadCartItems(userId);
  }

  Future<void> clearCart(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _cartRepository.clearCart(userId);
      _items = [];
    } catch (e) {
      debugPrint('Failed to clear cart for $userId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}