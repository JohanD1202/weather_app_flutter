import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitNotifier extends StateNotifier<bool> {
  static const _key = "unit_is_fahrenheit";

  UnitNotifier() : super(false) {
    _loadUnit();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_key);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}

final unitProvider = StateNotifierProvider<UnitNotifier, bool>((ref) => UnitNotifier());
