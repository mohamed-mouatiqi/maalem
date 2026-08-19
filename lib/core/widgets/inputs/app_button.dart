import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

/// Visual style of [AppButton]. "Disabled" is not here — it's a state
/// (onPressed == null), not a variant, so it applies to any of these.
enum AppButtonVariant { primary, success, outlined, tonal }

/// Full-width action button used across the app (forms, auth flow, dialogs).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
     this.svgIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final String? svgIcon;
  final bool isLoading;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == AppButtonVariant.outlined;

    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          disabledBackgroundColor: _backgroundColor.withValues(alpha: 0.4),
          disabledForegroundColor: _foregroundColor.withValues(alpha: 0.6),
          elevation: 0,
          side: isOutlined
              ? BorderSide(
                  color: _isEnabled
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.4),
                  width: 1.4,
                )
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _foregroundColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null || svgIcon !=null) ...[
                    if(svgIcon != null)
                      SvgPicture.asset(svgIcon! , width: 20, height: 20,)
                    else 
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSizes.spacingSmall),
                  ],
                  Text(label, style: AppTextStyles.button),
                ],
              ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.success:
        return AppColors.success;
      case AppButtonVariant.outlined:
        return Colors.transparent;
      case AppButtonVariant.tonal:
        return AppColors.primaryContainer;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.success:
        return Colors.white;
      case AppButtonVariant.outlined:
      case AppButtonVariant.tonal:
        return AppColors.primary;
    }
  }
}
