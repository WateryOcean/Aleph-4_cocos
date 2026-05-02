import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const SettingSwitch({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.softMint),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: AppColors.deepPurple,
          onChanged: onChanged,
        ),
      ),
    );
  }
}