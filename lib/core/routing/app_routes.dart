/// Route path constants — avoids magic strings when navigating with go_router.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const languageSelection = '/language-selection';

  /// Not part of the real app flow — see ThemePreviewScreen.
  static const devPreview = '/dev-preview';
}
