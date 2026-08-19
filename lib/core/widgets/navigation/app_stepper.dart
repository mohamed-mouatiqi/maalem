import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

/// Numbered step progress indicator (e.g. Sign Up step 2 of 3).
class AppStepper extends StatelessWidget {
  const AppStepper({super.key, required this.stepCount, required this.currentStep});

  final int stepCount;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stepCount * 2 - 1, (i) {
        if (i.isEven) {
          final stepIndex = i ~/ 2;
          final isActive = stepIndex <= currentStep;
          return CircleAvatar(
            radius: 14,
            backgroundColor: isActive ? AppColors.primary : AppColors.outline,
            child: Text(
              '${stepIndex + 1}',
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? Colors.white : AppColors.textTertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        final lineIndex = i ~/ 2;
        final isActive = lineIndex < currentStep;
        return Expanded(
          child: Container(
            height: 2,
            color: isActive ? AppColors.primary : AppColors.outline,
          ),
        );
      }),
    );
  }
}
