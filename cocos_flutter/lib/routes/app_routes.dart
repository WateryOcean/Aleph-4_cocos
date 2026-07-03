import 'package:cocos_flutter/features/auth/views/login_page.dart';
import 'package:cocos_flutter/features/auth/views/register_page.dart';
import 'package:cocos_flutter/features/auth/views/signin_page.dart';
import 'package:cocos_flutter/features/cart/views/cart_page.dart';
import 'package:cocos_flutter/features/chat/models/chat_model.dart';
import 'package:cocos_flutter/features/chat/views/chat_detail_page.dart';
import 'package:cocos_flutter/features/chat/views/chat_list_page.dart';
import 'package:cocos_flutter/features/checkout/view/checkout_page.dart';
import 'package:cocos_flutter/features/events/models/event_model.dart';
import 'package:cocos_flutter/features/events/views/event_detail_page.dart';
import 'package:cocos_flutter/features/events/views/event_page.dart';
import 'package:cocos_flutter/features/home/home_page.dart';
import 'package:cocos_flutter/features/home/special_offers_page.dart';
import 'package:cocos_flutter/features/orders/models/order_model.dart';
import 'package:cocos_flutter/features/orders/views/order_detail_page.dart';
import 'package:cocos_flutter/features/orders/views/order_list_page.dart';
import 'package:cocos_flutter/features/product/models/product_model.dart';
import 'package:cocos_flutter/features/product/views/product_detail_page.dart';
import 'package:cocos_flutter/features/profile/views/profile_page.dart';
import 'package:cocos_flutter/features/profile/views/edit_profile_page.dart';
import 'package:cocos_flutter/features/profile/views/address_page.dart';
import 'package:cocos_flutter/features/profile/views/privacy_policy_page.dart';
import 'package:cocos_flutter/features/profile/views/help_center_page.dart';
import 'package:cocos_flutter/features/search/views/search_page.dart';
import 'package:cocos_flutter/features/welcome/splash_page.dart';
import 'package:cocos_flutter/features/welcome/welcome_page1.dart';
import 'package:cocos_flutter/features/welcome/welcome_page2.dart';
import 'package:cocos_flutter/features/welcome/welcome_page3.dart';
import 'package:flutter/material.dart';
 
class AppRoutes {
  // Nama Rute
  static const String splash = '/';
  static const String welcome1 = '/welcome1';
  static const String welcome2 = '/welcome2';
  static const String welcome3 = '/welcome3';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String home = '/home';
  static const String search = '/search';
  static const String specialOffers = '/special-offers';
  static const String productDetail = '/product-detail';
  static const String events = '/events';
  static const String eventDetail = '/event-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String chat = '/chat';
  static const String chatDetail = '/chat-detail';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String address = '/address';
  static const String privacyPolicy = '/privacy-policy';
  static const String helpCenter = '/help-center';
  static const String orderList = '/order-list';
  static const String orderDetail = '/order-detail';
 
  // Peta Navigasi
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    welcome1: (context) => const WelcomeScreen1(),
    welcome2: (context) => const WelcomeScreen2(),
    welcome3: (context) => const WelcomeScreen3(),
    login: (context) => const LoginPage(),
    signup: (context) => const RegisterPage(),
    signin: (context) => const SignInPage(),
    home: (context) => const HomePage(),
    search: (context) => const SearchPage(),
    specialOffers: (context) => const SpecialOffersPage(),
    productDetail: (context) => const ProductDetailPage(),
    events: (context) => const EventPage(),
    eventDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return args is EventModel
          ? EventDetailPage(event: args)
          : _missingArgumentPage(context, 'Event not found.');
    },
    cart: (context) => const CartPage(),
    checkout: (context) => const CheckoutPage(),
    chat: (context) => const ChatListPage(),
    chatDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return args is ChatConversation
          ? ChatDetailPage(conversation: args)
          : _missingArgumentPage(context, 'Chat conversation not found.');
    },
    profile: (context) => const ProfilePage(),
    editProfile: (context) => const EditProfilePage(),
    address: (context) => const AddressPage(),
    privacyPolicy: (context) => const PrivacyPolicyPage(),
    helpCenter: (context) => const HelpCenterPage(),
    orderList: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return args is OrderCategory
          ? OrderListPage(category: args)
          : _missingArgumentPage(context, 'Order category not found.');
    },
    orderDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return args is Order
          ? OrderDetailPage(order: args)
          : _missingArgumentPage(context, 'Order details not found.');
    },
  };
 
  static Widget _missingArgumentPage(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Error', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 64),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  // Helper Navigasi
 
  static void goToWelcome1(BuildContext context) {
    Navigator.pushReplacementNamed(context, welcome1);
  }
 
  static void goToWelcome2(BuildContext context) {
    Navigator.pushNamed(context, welcome2);
  }
 
  static void goToWelcome3(BuildContext context) {
    Navigator.pushNamed(context, welcome3);
  }
 
  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }
 
  static void goToSignUp(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }
 
  static void goToSignIn(BuildContext context) {
    Navigator.pushNamed(context, signin);
  }
 
  static void loginSuccess(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
  }
 
  static void goToSpecialOffers(BuildContext context) {
    Navigator.pushNamed(context, specialOffers);
  }

  static void goToProductDetail(BuildContext context, ProductModel product) {
    Navigator.pushNamed(context, productDetail, arguments: product);
  }
 
  static void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }
 
  static void goToSearch(BuildContext context, {String? keyword}) {
    Navigator.pushNamed(context, search, arguments: keyword);
  }
 
  static void goToEvents(BuildContext context) {
    Navigator.pushNamed(context, events);
  }
 
  static void goToEventDetail(BuildContext context, EventModel event) {
    Navigator.pushNamed(context, eventDetail, arguments: event);
  }
 
  static void goToCart(BuildContext context) {
    Navigator.pushNamed(context, cart);
  }
 
  static void goToCheckout(BuildContext context) {
    Navigator.pushNamed(context, checkout);
  }
 
  static void goToChat(BuildContext context) {
    Navigator.pushNamed(context, chat);
  }
 
  static void goToChatDetail(
      BuildContext context, ChatConversation conversation) {
    Navigator.pushNamed(context, chatDetail, arguments: conversation);
  }
 
  /// Navigasi ke daftar pesanan untuk [OrderCategory] tertentu.
  static void goToOrderList(BuildContext context, OrderCategory category) {
    Navigator.pushNamed(context, orderList, arguments: category);
  }
 
  /// Navigasi ke halaman detail untuk [Order] tertentu.
  static void goToOrderDetail(BuildContext context, Order order) {
    Navigator.pushNamed(context, orderDetail, arguments: order);
  }
}