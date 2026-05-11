import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final IconData fallbackIcon;
  final double? width;
  final double? height;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.restaurant,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: width,
          height: height,
          color: AppColors.border.withValues(alpha: 0.35),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: AppColors.border.withValues(alpha: 0.45),
          alignment: Alignment.center,
          child: Icon(fallbackIcon, color: AppColors.primary, size: 34),
        );
      },
    );
  }
}
