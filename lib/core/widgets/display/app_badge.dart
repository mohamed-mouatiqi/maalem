import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

/// Status this [AppBadge] represents — each maps to a color from AppColors.
enum AppBadgeStatus { completed, ongoing, upcoming, cancelled, verified }

/// Small status pill (booking status, verified craftsman, etc.) with a
/// soft-tinted background instead of a solid fill.
class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, required this.status});

  final String label;
  final AppBadgeStatus status;

  Color get _color {
    switch (status) {
      case AppBadgeStatus.completed:
        return AppColors.success;
      case AppBadgeStatus.ongoing:
        return AppColors.warning;
      case AppBadgeStatus.upcoming:
        return AppColors.textSecondary;
      case AppBadgeStatus.cancelled:
        return AppColors.error;
      case AppBadgeStatus.verified:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == AppBadgeStatus.verified) ...[
            Icon(Icons.verified_rounded, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
