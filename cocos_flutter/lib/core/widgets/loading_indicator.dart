import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? const Color(0xFF8B5CF6)),
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}

// Overlay version for full screen loading
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground.withValues(alpha: 0.7),
      body: const CustomLoadingIndicator(),
    );
  }
}
