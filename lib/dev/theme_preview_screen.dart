import 'package:flutter/material.dart';

import '../core/widgets/widgets.dart';

/// Dev-only scratch screen showing every core/widgets component together.
/// Not part of the real app flow — delete once real screens cover this.
class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Preview')),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
        items: const [
          AppNavItem(icon: Icons.home_rounded, label: 'Home'),
          AppNavItem(icon: Icons.calendar_today_rounded, label: 'Bookings'),
          AppNavItem(icon: Icons.chat_bubble_rounded, label: 'Chat'),
          AppNavItem(icon: Icons.favorite_rounded, label: 'Favorites'),
          AppNavItem(icon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                AppBadge(label: 'Completed', status: AppBadgeStatus.completed),
                AppBadge(label: 'Ongoing', status: AppBadgeStatus.ongoing),
                AppBadge(label: 'Upcoming', status: AppBadgeStatus.upcoming),
                AppBadge(label: 'Cancelled', status: AppBadgeStatus.cancelled),
                AppBadge(label: 'Verified', status: AppBadgeStatus.verified),
              ],
            ),
            const SizedBox(height: 12),
            const AppRating(rating: 4.9, reviewCount: 128),
            const SizedBox(height: 24),

            const AppStepper(stepCount: 3, currentStep: 1),
            const SizedBox(height: 24),

            AppCard(
              onTap: () {},
              child: Row(
                children: [
                  const CircleAvatar(radius: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yassine Plumbing',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Text('Plumber · 15 min away'),
                      ],
                    ),
                  ),
                  const Icon(Icons.favorite_border_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const AppSkeleton(height: 20, width: 160),
            const SizedBox(height: 8),
            const AppSkeleton(height: 14),
            const SizedBox(height: 24),

            AppButton(
              label: 'Show confirm dialog',
              variant: AppButtonVariant.outlined,
              onPressed: () async {
                final confirmed = await showAppConfirmDialog(
                  context,
                  title: 'Cancel this booking?',
                  message:
                      'The craftsman will be notified. Cancellation within 3h may incur a fee.',
                  confirmLabel: 'Cancel',
                  cancelLabel: 'Keep',
                  isDestructive: true,
                );
                if (confirmed && context.mounted) {
                  AppSnackbar.showError(context, 'Booking cancelled.');
                }
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Show success snackbar',
              variant: AppButtonVariant.tonal,
              onPressed: () => AppSnackbar.showSuccess(context, 'Booking confirmed.'),
            ),
          ],
        ),
      ),
    );
  }
}
