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
import 'package:cocos_flutter/features/product/views/product_detail_page.dart';
import 'package:cocos_flutter/features/profile/views/profile_page.dart';
import 'package:cocos_flutter/features/search/views/search_page.dart';
import 'package:cocos_flutter/features/welcome/splash_page.dart';
import 'package:cocos_flutter/features/welcome/welcome_page1.dart';
import 'package:cocos_flutter/features/welcome/welcome_page2.dart';
import 'package:cocos_flutter/features/welcome/welcome_page3.dart';
import 'package:flutter/material.dart';
 
class AppRoutes {
  // Route Names
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
  static const String orderList = '/order-list';
  static const String orderDetail = '/order-detail';
 
  // Navigation Map
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
    eventDetail: (context) => EventDetailPage(
      event: ModalRoute.of(context)!.settings.arguments as EventModel,
    ),
    cart: (context) => const CartPage(),
    checkout: (context) => const CheckoutPage(),
    chat: (context) => const ChatListPage(),
    chatDetail: (context) => ChatDetailPage(
      conversation:
          ModalRoute.of(context)!.settings.arguments as ChatConversation,
    ),
    profile: (context) => const ProfilePage(),
    orderList: (context) => OrderListPage(
      category:
          ModalRoute.of(context)!.settings.arguments as OrderCategory,
    ),
    orderDetail: (context) => OrderDetailPage(
      order: ModalRoute.of(context)!.settings.arguments as Order,
    ),
  };
 
  // ── Navigation Helpers ──────────────────────────────────────────────────
 
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
 
  /// Navigate to the order list for a specific [OrderCategory].
  static void goToOrderList(BuildContext context, OrderCategory category) {
    Navigator.pushNamed(context, orderList, arguments: category);
  }
 
  /// Navigate to the detail page for a specific [Order].
  static void goToOrderDetail(BuildContext context, Order order) {
    Navigator.pushNamed(context, orderDetail, arguments: order);
  }
}