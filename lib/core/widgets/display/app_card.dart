import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

/// Generic tappable card container using the app's CardTheme. Business-specific
/// cards (e.g. a craftsman listing) compose this rather than styling their own.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.spacingMedium),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
