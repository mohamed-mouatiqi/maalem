import 'package:go_router/go_router.dart';

import '../../dev/theme_preview_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/splash_screens.dart';
import 'app_routes.dart';

/// App-wide go_router config. Add one GoRoute per screen here as they're built.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreens(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.languageSelection,
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.devPreview,
      builder: (context, state) => const ThemePreviewScreen(),
    ),
  ],
);
