import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const MaalemApp());
}

class MaalemApp extends StatelessWidget {
  const MaalemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CraftConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ThemePreviewScreen(),
    );
  }
}

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Preview')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Headline', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Filled Primary')),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            const SizedBox(height: 12),
            TextButton(onPressed: () {}, child: const Text('Text Button')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(hintText: 'Phone Number')),
          ],
        ),
      ),
    );
  }
}
