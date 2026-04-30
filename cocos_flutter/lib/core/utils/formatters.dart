import 'package:intl/intl.dart';

class AppFormatters {
  // Format harga ke dalam format USD (e.g., $100.00)
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }

  // Format tanggal ke dalam format hari, tanggal, dan tahun (e.g., Oct 25, 2023)
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  // Format tanggal dengan waktu (e.g., Oct 25, 2023 14:30)
  static String formatDateTime(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  // Format angka menjadi format numerik (e.g., 1,234)
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}
