import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/widgets/feedback/app_snackbar.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';
import 'package:maalem/core/widgets/inputs/app_otp_input.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';

const _resendCooldownSeconds = 25;

/// Last step of Sign Up: confirm the phone number with an OTP. The countdown
/// is local UI state (Timer + setState) — nothing outside this screen needs
/// to know "how many seconds are left".
class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  Timer? _timer;
  int _secondsRemaining = _resendCooldownSeconds;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = _resendCooldownSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onVerify() {
    if (_code.length < 6) {
      AppSnackbar.showError(context, 'Enter the 6-digit code.');
      return;
    }
    // TODO: call AuthRepository.verifyPhone(code) once the backend is wired.
    context.push(AppRoutes.customerLocalisation);
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.watch<SignUpCubit>().state.phone;
    final displayPhone = phone.isEmpty ? '+212 6 12 34 56 78' : phone;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.success.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.phone_iphone_rounded,
                    color: AppColors.success,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Text('Verify Your Phone', textAlign: TextAlign.center, style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(
                'Enter the 6-digit code sent to',
                textAlign: TextAlign.center,
                style: AppTextStyles.withColor(
                  AppTextStyles.bodyMedium,
                  AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(displayPhone, style: AppTextStyles.title),
                      const SizedBox(width: AppSizes.spacingSmall),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Edit',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyMedium,
                            AppColors.success,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              AppOtpInput(
                onChanged: (value) => _code = value,
                onCompleted: (value) => _code = value,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Center(
                child: _secondsRemaining > 0
                    ? Text.rich(
                        TextSpan(
                          text: 'Resend code in ',
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyMedium,
                            AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: AppTextStyles.withColor(
                                AppTextStyles.bodyMedium,
                                AppColors.success,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: _startCountdown,
                        child: const Text('Resend code'),
                      ),
              ),
              const Spacer(),
              AppButton(label: 'Verify', onPressed: _onVerify),
              const SizedBox(height: AppSizes.spacingSmall),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Change phone number'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
