import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingSection extends StatelessWidget {
  final String title;

  const SettingSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}