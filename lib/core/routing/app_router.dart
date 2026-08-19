import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maalem/features/customer/presentation/screens/localisation_sign_up_screen.dart';
import 'package:maalem/features/customer/presentation/screens/onboarding_screen.dart';
import 'package:maalem/features/customer/presentation/screens/phone_verification_screen.dart';
import 'package:maalem/features/customer/presentation/screens/sign_up_screen.dart';
import 'package:maalem/features/onboarding/cubit/sign_up_cubit.dart';
import 'package:maalem/features/onboarding/presentation/screens/choose_role_screen.dart';
import 'package:maalem/features/onboarding/presentation/screens/language_selection_screen.dart';
import 'package:maalem/features/onboarding/presentation/screens/splash_screen.dart';

import '../../dev/theme_preview_screen.dart';
import 'app_routes.dart';

/// App-wide go_router config. Add one GoRoute per screen here as they're built.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Language Selection → Choose Role → Customer flow all share one
    // SignUpCubit instance, provided here so it survives navigation between
    // them and is disposed once the user leaves this group of routes.
    // Craftsman routes will join this same ShellRoute once that flow exists.
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => SignUpCubit(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.languageSelection,
          builder: (context, state) => const LanguageSelectionScreen(),
        ),
        GoRoute(
          path: AppRoutes.chooseRole,
          builder: (context, state) => const ChooseRoleScreen(),
        ),
        GoRoute(
          path: AppRoutes.customerOnboarding,
          builder: (context, state) => const CustomerOnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.customerSignUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.customerPhoneVerification,
          builder: (context, state) => const PhoneVerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.customerLocalisation,
          builder: (context, state) => const LocalisationSignUpScreen(),
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.devPreview,
      builder: (context, state) => const ThemePreviewScreen(),
    ),
  ],
);
