import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const CoCosApp());
}

class CoCosApp extends StatelessWidget {
  const CoCosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoCos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      
      // Aplikasi dimulai dengan SplashScreen, lalu navigasi ke Home Page
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
