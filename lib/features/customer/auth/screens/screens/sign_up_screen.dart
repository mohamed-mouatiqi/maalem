import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/widgets/feedback/app_snackbar.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';

/// Entry point of the Sign Up flow: Google shortcut or phone number.
/// Only phone is wired end-to-end (push to Phone Verification); Google is a
/// TODO until google_sign_in + a backend endpoint exist.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = '';

  void _onConnectWithGoolge() {
    // TODO: wire google_sign_in + backend OAuth endpoint.
    AppSnackbar.showError(context, 'Google sign-in is coming soon.');
  }
void _onConnectWithApple() {
    // TODO: wire apple_sign_in + backend OAuth endpoint.
    AppSnackbar.showError(context, 'Apple sign-in is coming soon.');
  }
  void _onContinue() {
    // Runs every field's validator (including IntlPhoneField's built-in
    // per-country length check) and paints red borders/error text on
    // whichever ones fail — nothing to do manually here.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<SignUpCubit>();
    cubit.updateStep1(
      fullName: cubit.state.fullName,
      phone: _completePhoneNumber,
      email: cubit.state.email,
    );
    context.push(AppRoutes.customerPhoneVerification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryContainer,
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                Text(
                  'Log In or Sign Up',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 6),
                Text(
                  'Join as a customer in just a few seconds',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodyLarge,
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                AppButton(
                  label: 'Connect with Google',
                  variant: AppButtonVariant.outlined,
                  svgIcon: 'assets/icons/google-icon.svg',
                  onPressed: _onConnectWithGoolge,
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                AppButton(
                  label: 'Connect with Apple',
                  variant: AppButtonVariant.outlined,
                  svgIcon: 'assets/icons/apple-icon.svg',
                  onPressed: _onConnectWithApple,
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingSmall,
                      ),
                      child: Text(
                        'or',
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall,
                          AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                Text(
                  'Continue with phone number',
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodySmall,
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                // phone number   intlphone number
                IntlPhoneField(
                  initialCountryCode: 'MA',
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.bodyMedium,
                  dropdownTextStyle: AppTextStyles.bodyMedium,
                  invalidNumberMessage: 'Enter a valid phone number',
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.textTertiary,
                    ),
                  ),
                  dropdownIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                  pickerDialogStyle: PickerDialogStyle(
                    backgroundColor: AppColors.surface,
                    countryNameStyle: AppTextStyles.bodyMedium,
                    countryCodeStyle: AppTextStyles.withColor(
                      AppTextStyles.bodyMedium,
                      AppColors.textSecondary,
                    ),
                    searchFieldInputDecoration: InputDecoration(
                      hintText: 'Search country',
                      hintStyle: AppTextStyles.withColor(
                        AppTextStyles.bodyMedium,
                        AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textTertiary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        borderSide: const BorderSide(color: AppColors.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (phone) {
                    _completePhoneNumber = phone.completeNumber;
                  },
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                    Expanded(
                      child: Text(
                        "We'll send you a 6-digit verification code to confirm your number.",
                        style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall,
                          AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: AppTextStyles.withColor(
                        AppTextStyles.bodySmall,
                        AppColors.textTertiary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingLarge),
                AppButton(label: 'Continue', onPressed: _onContinue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
