import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen language code across app restarts. Kept in
/// core/ (not features/auth/) because any screen — not just onboarding —
/// may need to read it later (e.g. a future Settings screen).
class LanguageStorage {
  LanguageStorage._();

  static const _key = 'language_code';

  static Future<void> save(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
