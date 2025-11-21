import 'package:flutter/material.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/widgets/shared/weather_bottom_navigation.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavWrapper(state: state),
        );
      },
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
        GoRoute(
          path: '/favorites',
          name: FavoritesScreen.name,
          builder: (context, state) {
            return const FavoritesScreen();
          }
        ),
        GoRoute(
          path: '/settings',
          name: SettingsScreen.name,
          builder: (context, state) {
            return const SettingsScreen();
          }
        ),
      ],
    )
  ],
);

