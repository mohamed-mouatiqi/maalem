import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/widgets/display/app_card.dart';
import 'package:maalem/core/widgets/feedback/app_snackbar.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_state.dart';

/// Lets a new user pick which side of the marketplace they're joining.
/// Language is already chosen by this point (see LanguageSelectionScreen),
/// so this screen only needs to decide Customer vs Craftsman.
/// StatelessWidget: the choice itself is written straight to SignUpCubit
/// (provided by the ShellRoute above this screen), there's no local UI
/// state to hold here.
class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    context.read<SignUpCubit>().selectRole(role);
    if (role == UserRole.customer) {
      context.push(AppRoutes.customerOnboarding);
    } else {
      // TODO: navigate to Craftsman onboarding once that flow exists.
      AppSnackbar.showError(context, 'Craftsman sign up is coming soon.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Text('Join Maalem', textAlign: TextAlign.center, style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'Choose how you want to use the app',
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyLarge,
                  AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              _RoleCard(
                icon: Icons.person_rounded,
                iconColor: AppColors.primary,
                iconBackground: AppColors.primaryContainer,
                title: "I'm a Customer",
                subtitle: 'Book trusted craftsmen for your needs',
                onTap: () => _selectRole(context, UserRole.customer),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              _RoleCard(
                icon: Icons.work_rounded,
                iconColor: AppColors.success,
                iconBackground: AppColors.success.withValues(alpha: 0.12),
                title: "I'm a Craftsman",
                subtitle: 'Offer your services and grow your business',
                onTap: () => _selectRole(context, UserRole.craftsman),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.success.withValues(alpha: 0.12),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Safe & Secure', style: AppTextStyles.title),
                        Text(
                          'Your data is protected and never shared.',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  // TODO: navigate to Login once that screen exists.
                  onPressed: () {},
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyMedium,
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconBackground,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSizes.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                Text(
                  subtitle,
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodySmall,
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
