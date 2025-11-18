import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/saved',
      name: SavedScreen.name,
      builder: (context, state) => const SavedScreen(),
    ),
    GoRoute(
      path: '/weather-detail',
      name: WeatherDetailScreen.name,
      builder: (context, state) {
        final weather = state.extra as Weather;

        return WeatherDetailScreen(weather: weather);
      },
    ),
  ]
);