import 'package:go_router/go_router.dart';

import '../../dev/theme_preview_screen.dart';
import 'app_routes.dart';

/// App-wide go_router config. Add one GoRoute per screen here as they're built.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const ThemePreviewScreen(),
    ),
  ],
);
