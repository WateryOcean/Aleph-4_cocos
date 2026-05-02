// lib/routes/app_routes.dart
import 'package:cocos_flutter/features/auth/views/login_page.dart';
import 'package:cocos_flutter/features/auth/views/register_page.dart';
import 'package:cocos_flutter/features/auth/views/signin_page.dart';
import 'package:cocos_flutter/features/home/home_page.dart';
import 'package:cocos_flutter/features/home/special_offers_page.dart';
import 'package:cocos_flutter/features/product/views/product_detail_page.dart';
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
  static const String cart = '/cart';
  static const String profile = '/profile';

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
    // events: (context) => const EventPage(),
    // cart: (context) => const CartPage(), // Placeholder
    // profile: (context) => const ProfilePage(), // Placeholder
  };

  // Navigation Helpers
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

  // static void goToProfile(BuildContext context) {
  //   Navigator.pushNamed(context, profile);
  // }

  static void goToSearch(BuildContext context, {String? keyword}) {
    Navigator.pushNamed(context, search, arguments: keyword);
  }
}
