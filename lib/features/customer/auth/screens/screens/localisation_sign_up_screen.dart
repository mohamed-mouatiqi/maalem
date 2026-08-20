import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/services/geocoding_service.dart';
import 'package:maalem/core/widgets/feedback/app_snackbar.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';

/// Debounce delay before firing a geocoding request, and the minimum query
/// length worth searching for — avoids spamming the API on every keystroke.
const _searchDebounce = Duration(milliseconds: 400);
const _minQueryLength = 3;

/// Final step of the Sign Up flow, right after phone verification:
/// location + terms, then creates the account.
class LocalisationSignUpScreen extends StatefulWidget {
  const LocalisationSignUpScreen({super.key});

  @override
  State<LocalisationSignUpScreen> createState() => _LocalisationSignUpScreenState();
}

class _LocalisationSignUpScreenState extends State<LocalisationSignUpScreen> {
  late final TextEditingController _locationController;
  final _geocodingService = GeocodingService();
  Timer? _debounce;
  List<LocationSuggestion> _suggestions = [];
  bool _isSearching = false;
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
    _debounce?.cancel();
    super.dispose();
  }

  void _onLocationQueryChanged(String query) {
    _debounce?.cancel();
    setState(() => _suggestions = []);

    if (query.trim().length < _minQueryLength) return;

    _debounce = Timer(_searchDebounce, () async {
      setState(() => _isSearching = true);
      final results = await _geocodingService.search(query);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    });
  }

  void _onSuggestionSelected(LocationSuggestion suggestion) {
    _locationController.text = suggestion.label;
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
  }

  void _onCreateAccount() {
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
        child: SingleChildScrollView(
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
              TextField(
                controller: _locationController,
                onChanged: _onLocationQueryChanged,
                decoration: InputDecoration(
                  hintText: 'Search place ....',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
              ),
              if (_suggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.spacingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final suggestion in _suggestions)
                        ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.textTertiary,
                          ),
                          title: Text(suggestion.label, style: AppTextStyles.bodyMedium),
                          onTap: () => _onSuggestionSelected(suggestion),
                        ),
                    ],
                  ),
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
              const SizedBox(height: AppSizes.spacingLarge),
              AppButton(
                label: 'Create Account',
                onPressed: _agreedToTerms ? _onCreateAccount : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
