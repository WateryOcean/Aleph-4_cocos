import 'package:flutter/material.dart';
import '../widgets/loading_indicator.dart';

class AppNavigation {
  /// Navigates ke halaman utama dengan menampilkan loading indicator selama 2 detik.
  static Future<void> navigateWithLoading(BuildContext context, String routeName) async {
    try {
      // 1. Menunjukkan loading indicator (don't await - show it without blocking)
      if (!context.mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const FullScreenLoader(),
      );

      // 2. Simulasi proses loading selama 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // 3. Remove overlay loading indicator using root navigator
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // 4. Navigate ke HomePage dan clear stack
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
      }
    } catch (e) {
      print('Navigation error: $e');
      if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }
}
