import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const PaymentMethodTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: title,
      groupValue: 'Transfer Bank', // Contoh statis
      onChanged: (value) {},
      title: Text(title),
      secondary: Icon(icon),
      contentPadding: EdgeInsets.zero,
    );
  }
}