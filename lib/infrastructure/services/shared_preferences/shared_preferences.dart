import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/entities/weather.dart';

Future<List<Weather>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = prefs.getStringList('favorites') ?? [];
  return jsonList.map((e) => Weather.fromJson(jsonDecode(e))).toList();
}

Future<void> toggleFavorite(Weather weather) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = prefs.getStringList('favorites') ?? [];

  final weatherJson = jsonEncode(weather.toJson());

  if (jsonList.contains(weatherJson)) {
    jsonList.remove(weatherJson);
  } else {
    jsonList.add(weatherJson);
  }

  await prefs.setStringList('favorites', jsonList);
}
