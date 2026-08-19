/// Route path constants — avoids magic strings when navigating with go_router.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';

  // Shared, role-agnostic: shown once, before Customer/Craftsman fork.
  static const chooseRole = '/choose-role';
  static const languageSelection = '/language-selection';

  // Customer-only flow, in order: Onboarding -> Sign Up (Google/phone) ->
  // Phone Verification -> Localisation (location + terms, finalizes account).
  static const customerOnboarding = '/customer/onboarding';
  static const customerSignUp = '/customer/sign-up';
  static const customerPhoneVerification = '/customer/verify-phone';
  static const customerLocalisation = '/customer/localisation';

  /// Not part of the real app flow — see ThemePreviewScreen.
  static const devPreview = '/dev-preview';
}
