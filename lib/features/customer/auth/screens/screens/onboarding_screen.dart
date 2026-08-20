import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/core/constants/app_colors.dart';
import 'package:maalem/core/constants/app_sizes.dart';
import 'package:maalem/core/constants/app_text_styles.dart';
import 'package:maalem/core/routing/app_routes.dart';
import 'package:maalem/core/widgets/inputs/app_button.dart';

/// Static content for one onboarding slide. Not a domain model — it never
/// comes from the backend, so it stays private to this screen rather than
/// living in features/customer/data/models/.
class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}

/// The 3 onboarding slides, in swipe order.
const _pages = [
  _OnboardingPage(
    image: 'assets/images/onboarding/construction-pana.svg',
    title: 'Trusted professionals for every task',
    description:
        'Book verified craftsmen for home repairs, installations and more.',
  ),
  _OnboardingPage(
    image: 'assets/images/onboarding/cleaning service-pana.svg',
    title: 'Book in seconds',
    description: 'Find the right craftsman near you and schedule instantly.',
  ),
  _OnboardingPage(
    image: 'assets/images/onboarding/hander-rafiki.svg',
    title: 'Pay securely, work guaranteed',
    description: 'Track your booking and pay safely once the job is done.',
  ),
];

/// Swipeable intro carousel shown once after Splash. StatefulWidget (not a
/// Cubit) because the current-page index is transient UI state, not
/// something any other part of the app needs to know about.
class CustomerOnboardingScreen extends StatefulWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  State<CustomerOnboardingScreen> createState() => _CustomerOnboardingScreenState();
}

class _CustomerOnboardingScreenState extends State<CustomerOnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_isLastPage) {
      context.push(AppRoutes.customerSignUp);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.customerSignUp),
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 220, child: SvgPicture.asset(page.image)),
                        const SizedBox(height: AppSizes.spacingLarge),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: AppSizes.spacingSmall),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.withColor(
                            AppTextStyles.bodyLarge,
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              AppButton(
                label: _isLastPage ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),
              const SizedBox(height: AppSizes.spacingMedium),
            ],
          ),
        ),
      ),
    );
  }
}
