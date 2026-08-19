import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/services/language_storage.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';

/// One selectable language. Not a domain model — just display data for
/// this screen, same reasoning as _OnboardingPage.
class _LanguageOption {
  const _LanguageOption({required this.code, required this.nativeName, required this.name});

  final String code;
  final String nativeName;
  final String name;
}

const _languages = [
  _LanguageOption(code: 'ar', nativeName: 'العربية', name: 'Arabic'),
  _LanguageOption(code: 'fr', nativeName: 'Français', name: 'French'),
  _LanguageOption(code: 'en', nativeName: 'English', name: 'English'),
];

/// Lets the user pick a language and persists it via LanguageStorage.
/// The selected radio is local UI state; only the saved value on disk is
/// the "real" app-wide state (read later by whatever wires up full i18n).
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedCode = _languages.first.code;
  bool _isSaving = false;

  Future<void> _onContinue() async {
    setState(() => _isSaving = true);
    await LanguageStorage.save(_selectedCode);
    if (!mounted) return;
    setState(() => _isSaving = false);
    context.push(AppRoutes.chooseRole);
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
              Align(
                alignment: AlignmentGeometry.center,
                child: Text('Choose Language', style: AppTextStyles.h1),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Align(
                alignment: AlignmentGeometry.center,
                child: Text(
                  'Select your preferred language to continue',
                  style: AppTextStyles.withColor(
                    AppTextStyles.bodyLarge,
                    AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              for (final language in _languages)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacingSmall),
                  child: _LanguageTile(
                    code: language.code,
                    label: language.nativeName,
                    subtitle: language.name,
                    selected: _selectedCode == language.code,
                    onTap: () => setState(() => _selectedCode = language.code),
                  ),
                ),
              const Spacer(),
              AppButton(
                label: 'Continue',
                isLoading: _isSaving,
                onPressed: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.code,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMedium,
          vertical: AppSizes.spacingMedium,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: selected ? AppColors.primary : AppColors.surfaceAlt,
              child: Text(
                code.toUpperCase(),
                style: AppTextStyles.withColor(
                  AppTextStyles.bodySmall,
                  selected ? Colors.white : AppColors.textSecondary,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: selected
                        ? AppTextStyles.withColor(
                            AppTextStyles.title,
                            AppColors.primary,
                          )
                        : AppTextStyles.title,
                  ),
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
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}
