import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/favorites_provider.dart';
import 'package:weather_app/presentation/widgets/weather/weather_info.dart';

class WeatherDetailScreen extends ConsumerStatefulWidget {

  static const name = 'weather-detail-screen';
  final Weather weather;

  const WeatherDetailScreen({
    super.key,
    required this.weather
  });

  @override
  ConsumerState<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends ConsumerState<WeatherDetailScreen> {

  /*bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  void _loadFavorite() async {
    final favorites = await getFavorites();
    setState(() {
      isFavorite = favorites.any((w) => w.city == widget.weather.city);
    });
  }

  void _toggleFavorite() async {
    await toggleFavorite(widget.weather); // objeto completo
    final favorites = await getFavorites();
    setState(() {
      isFavorite = favorites.any((w) => w.city == widget.weather.city);
    });
  }*/

  @override
  Widget build(BuildContext context) {

    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((w) => w.city == widget.weather.city);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
            child: const Icon(
              LucideIcons.arrowLeft,
              size: 30,
              color: Colors.black,
            ),
            onTap: () => context.pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border),
              color: const Color.fromARGB(255, 255, 230, 0),
              iconSize: 30,
              onPressed: () {
                ref
                  .read(favoritesProvider.notifier)
                  .toggle(widget.weather);
              }
            ),
          )
        ]   
      ),
      body: WeatherInfo(weather: widget.weather),
    );
  }
}