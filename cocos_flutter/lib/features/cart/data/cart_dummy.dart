import '../models/cart_model.dart';

class CartDummyData {
  static final List<CartItem> dummyItems = [
    CartItem(
      id: '1',
      productName: 'Cyber Samurai Armor Set',
      imageUrl: 'assets/images/product1.png', // Pastikan path ini ada di pubspec.yaml
      price: 249.99,
      quantity: 1,
      selectedSize: 'L',
      selectedMaterial: 'Premium EVA Foam',
    ),
    CartItem(
      id: '2',
      productName: 'Ethereal Wing Prop',
      imageUrl: 'assets/images/product2.png',
      price: 89.50,
      quantity: 1,
      selectedSize: 'Custom',
      selectedMaterial: 'Worbla',
    ),
  ];

  static Cart get dummyCart => Cart(items: dummyItems);
}