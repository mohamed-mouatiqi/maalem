import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/widgets/feedback/app_snackbar.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';
import 'package:maalem/core/widgets/inputs/app_text_field.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';

/// Final step of the Sign Up flow, right after phone verification:
/// location + terms, then creates the account.
class LocalisationSignUpScreen extends StatefulWidget {
  const LocalisationSignUpScreen({super.key});

  @override
  State<LocalisationSignUpScreen> createState() => _LocalisationSignUpScreenState();
}

class _LocalisationSignUpScreenState extends State<LocalisationSignUpScreen> {
  late final TextEditingController _locationController;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(
      text: context.read<SignUpCubit>().state.location,
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (!_agreedToTerms) {
      AppSnackbar.showError(context, 'Please agree to the Terms & Conditions.');
      return;
    }
    context.read<SignUpCubit>()
      ..updateLocation(_locationController.text.trim())
      ..setAgreedToTerms(true);
    // TODO: call AuthRepository.signUp(cubit.state) once the backend is
    // wired, then navigate to Home once that screen exists.
    AppSnackbar.showSuccess(context, 'Account created!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'One last thing',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Text(
                'Location',
                style: AppTextStyles.withColor(AppTextStyles.bodySmall, AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              AppTextField(
                hintText: 'Search place ....',
                controller: _locationController,
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodySmall,
                            AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
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
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AppButton(label: 'Create Account', onPressed: _onCreateAccount),
            ],
          ),
        ),
      ),
    );
  }
}
