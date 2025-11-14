import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/weather/weather_repository_provider.dart';

final weatherProvider = FutureProvider.family<Weather, String>((ref, city) async {
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.getCurrentWeatherByCity(city);
});
