import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/entities/weather.dart';

class FavoritesNotifier extends StateNotifier<List<Weather>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favorites') ?? [];
    state = jsonList
        .map((e) => Weather.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> toggle(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favorites') ?? [];

    final encoded = jsonEncode(weather.toJson());

    if (jsonList.contains(encoded)) {
      jsonList.remove(encoded);
    } else {
      jsonList.add(encoded);
    }

    await prefs.setStringList('favorites', jsonList);
    await _loadFavorites();
  }

  Future<void> refresh() async {
    await _loadFavorites();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Weather>>(
  (ref) => FavoritesNotifier(),
);
