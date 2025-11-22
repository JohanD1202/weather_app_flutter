import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/weather/weather_repository_provider.dart';

class WeatherByCityNotifier extends AsyncNotifier<Weather?> {
  @override
  FutureOr<Weather?> build() {
    return null;
  }

  Future<void> search(String city) async {
    if (city.trim().isEmpty) return;

    state = const AsyncLoading();

    try {
      final repo = ref.read(weatherRepositoryProvider);
      final weather = await repo.getCurrentWeatherByCity(city);
      state = AsyncData(weather);
    } catch (e) {
      state = const AsyncData(null);
    }
  }

  Future<void> searchByCoords({
  required double lat,
  required double lon,
}) async {
  state = const AsyncLoading();

  try {
    final repo = ref.read(weatherRepositoryProvider);
    final weather = await repo.getCurrentWeatherByLocation(
      lat: lat,
      lon: lon
    );
    state = AsyncData(weather);
  } catch (e) {
    state = const AsyncData(null);
  }
}
}

final weatherByCityProvider =
    AsyncNotifierProvider<WeatherByCityNotifier, Weather?>(
  () => WeatherByCityNotifier(),
);
