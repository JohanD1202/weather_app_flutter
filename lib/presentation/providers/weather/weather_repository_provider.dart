import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/infrastructure/datasources/open_weather_datasource_impl.dart';
import 'package:weather_app/infrastructure/repositories/open_weather_repository_impl.dart';

final weatherRepositoryProvider = Provider((ref) {
  return OpenWeatherRepositoryImpl(OpenWeatherDatasourceImpl());
});