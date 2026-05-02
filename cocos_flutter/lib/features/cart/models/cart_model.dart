class CartItem {
  final String id;
  final String productName;
  final String imageUrl;
  final double price;
  int quantity;
  final String selectedSize;
  final String selectedMaterial;

  CartItem({
    required this.id,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.selectedSize = 'M',
    this.selectedMaterial = 'Standard',
  });

  double get totalItemPrice => price * quantity;
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalItemPrice);
  double get shippingFee => 0.0; 
  double get total => subtotal + shippingFee;
}