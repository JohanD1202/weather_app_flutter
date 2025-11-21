import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<String> {
  static const _key = "app_language";

  LanguageNotifier() : super("es") {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) state = saved;
  }

  Future<void> toggle() async {
    state = state == "es" ? "en" : "es";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
