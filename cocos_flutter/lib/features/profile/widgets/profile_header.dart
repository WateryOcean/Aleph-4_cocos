import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
        ),
        const SizedBox(height: 10),
        Text(
          user.name ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          user.phone ?? '',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class UserModel {
  String? get name => null;
  
  String? get phone => null;
  
  String? get image => null;
}