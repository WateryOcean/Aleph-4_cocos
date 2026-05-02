
import '../models/checkout_model.dart';

class CheckoutDummyData {
  static final ShippingAddress dummyAddress = ShippingAddress(
    fullName: 'John Doe',
    phoneNumber: '+1 234 567 890',
    addressLine: '123 Cosplay Lane, Sector 7',
    city: 'Neo Tokyo',
    postalCode: '10101',
  );

  static final List<String> paymentIcons = [
    'assets/icons/visa.png',
    'assets/icons/mastercard.png',
    'assets/icons/paypal.png',
  ];
}
