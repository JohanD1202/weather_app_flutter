import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_city.dart';

class SearchedWeatherNotifier extends StateNotifier<List<Weather>> {
  SearchedWeatherNotifier() : super([]);

  // Agrega un Weather a la lista
  void addWeather(Weather weather) {
    state = [...state, weather];
  }

  // Limpia la lista
  void clear() {
    state = [];
  }

  void removeWeather(Weather weather) {
    const epsilon = 0.00001; // tolerancia para comparaciones de doubles
    state = state.where((w) =>
      (w.lat - weather.lat).abs() > epsilon ||
      (w.lon - weather.lon).abs() > epsilon
    ).toList();
  }

  // 🔹 Refresh: actualiza los datos de cada ciudad, mantiene los cards
  Future<void> refresh(WidgetRef ref) async {
    List<Weather> updatedList = [];

    for (final weather in state) {
      try {
        await ref.read(weatherByCityProvider.notifier).search(weather.city);
        final updatedWeather = ref.read(weatherByCityProvider).value;
        if (updatedWeather != null) {
          updatedList.add(updatedWeather);
        } else {
          updatedList.add(weather);
        }
      } catch (_) {
        // Si falla, dejamos el dato anterior
        updatedList.add(weather);
      }
    }

    state = updatedList;
  }
}

// Provider moderno
final searchedWeatherProvider =
    StateNotifierProvider<SearchedWeatherNotifier, List<Weather>>(
  (ref) => SearchedWeatherNotifier(),
);
