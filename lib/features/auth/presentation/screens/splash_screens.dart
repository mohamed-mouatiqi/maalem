import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';

/// First screen shown on app launch. Purely static — no Cubit, since
/// navigation here is user-driven (buttons), not an auto auth-check redirect.
class SplashScreens extends StatelessWidget {
  const SplashScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLarge,
          ),
          child: Column(
            children: [
              const Spacer(),
              Text(
                "maalem",
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.h1,
                  AppColors.background,
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Text(
                "Find trusted craftsmen at your doorstep",
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyLarge,
                  AppColors.background,
                ),
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: 250,
                height: 200,
                child: SvgPicture.asset(
                  "assets/images/onboarding/process-cuate.svg",
                ),
              ),
              const Spacer(),
              AppButton(
                label: "Get Started",
                onPressed: () => context.go(AppRoutes.onboarding),
                variant: AppButtonVariant.tonal,
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              TextButton(
                onPressed: () {},
                child: Text(
                  "I already have an account",
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodyMedium,
                    AppColors.background,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }
}
