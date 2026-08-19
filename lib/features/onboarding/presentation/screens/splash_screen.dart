import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';

/// True app entry point: brief branding only, then forwards to Language
/// Selection (language is picked before role, since it affects how Choose
/// Role itself renders — e.g. RTL for Arabic). The old illustrated splash
/// (with "Get Started"/"I already have an account") was retired.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.languageSelection);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text(
          'maalem',
          style: AppTextStyles.withColor(AppTextStyles.h1, AppColors.background),
        ),
      ),
    );
  }
}
