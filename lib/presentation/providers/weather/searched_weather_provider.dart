import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '/presentation/providers/providers.dart';
import '/domain/domain.dart';


class SearchedWeatherNotifier extends StateNotifier<List<Weather>> {
  SearchedWeatherNotifier() : super([]);

  void addWeather(Weather weather) {
    state = [...state, weather];
  }

  void clear() {
    state = [];
  }

  void removeWeather(Weather weather) {
    const epsilon = 0.00001;
    state = state.where((w) =>
      (w.lat - weather.lat).abs() > epsilon ||
      (w.lon - weather.lon).abs() > epsilon
    ).toList();
  }

  Future<void> refresh(WidgetRef ref) async {
    final api = ref.read(weatherRepositoryProvider);

    List<Weather> updatedList = [];

    for(final weather in state) {
      try {
        final refreshed = await api.getWeatherById(weather.id);
        final merged = refreshed.copyWith(
          lat: weather.lat,
          lon: weather.lon,
          city: weather.city,
          country: weather.country,
        );
        updatedList.add(merged);
      } catch (_) {
        updatedList.add(weather);
      }
    }
    state = updatedList;
  }
}

final searchedWeatherProvider =
    StateNotifierProvider<SearchedWeatherNotifier, List<Weather>>(
  (ref) => SearchedWeatherNotifier(),
);
