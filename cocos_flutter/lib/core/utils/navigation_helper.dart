import 'package:flutter/material.dart';
import '../widgets/loading_indicator.dart';

class AppNavigation {
  /// Menavigasi ke halaman utama dengan menampilkan loading indicator selama 2 detik.
  static Future<void> navigateWithLoading(BuildContext context, String routeName) async {
    try {
      // 1. Menunjukkan loading indicator (jangan di-await - tampilkan tanpa memblokir)
      if (!context.mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const FullScreenLoader(),
      );

      // 2. Simulasi proses loading selama 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // 3. Hapus overlay loading indicator menggunakan root navigator
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // 4. Navigasi ke HomePage dan kosongkan stack
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
      }
    } catch (e) {
      // Abaikan error navigasi secara diam-diam di produksi
      if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }
}
