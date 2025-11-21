import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/favorites_provider.dart.dart';
import 'package:weather_app/presentation/providers/preferences/unit_provider.dart';

class FavoritesScreen extends ConsumerWidget {

  static const name = "favorites-screen";

  const FavoritesScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final favorites = ref.watch(favoritesProvider);
    final styleTitle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 20
    );
    final styleText = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 15
    );
    final styleIcon = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(title: Text('Mis Favoritos'),
      titleTextStyle: styleTitle,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              context.push('/settings');
            },
            child: Icon(
              LucideIcons.settings,
              color: styleIcon,
              size: 25,
            ),
          ),
        )
      ],
      ),
      body: favorites.isEmpty
        ? Center(
          child: Text("Aún no tienes ciudades favoritas", 
          style: styleText
        ),
        )
        : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final weather = favorites[index];
          return GestureDetector(
            onTap: () => context.push(
              '/weather-detail',
              extra: weather
            ),
            child: _FavoritesCard(
              weather: weather,
              onRemove: () {
                ref
                  .read(favoritesProvider.notifier)
                  .toggle(weather);
              }
            ),
          );
        },
      ),
    );
  }
}

class _FavoritesCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback onRemove;

  const _FavoritesCard({
    required this.weather,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {

    final countryFullName = countryNames[weather.country] ?? weather.country;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            _InfoLocationCard(weather.city, countryFullName),
            const Spacer(),
            _InfoTemperatureCard(weather.temperature, weather.description),
            IconButton(
              icon: const Icon(Icons.star),
              color: Colors.yellow,
              iconSize: 25,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLocationCard extends StatelessWidget {
  
  final String city;
  final String country;

  const _InfoLocationCard(
    this.city,
    this.country
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Text(city, style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(country, style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500
        )),
      ],
    );
  }
}

class _InfoTemperatureCard extends ConsumerWidget {

  final double temperature;
  final String description;

  const _InfoTemperatureCard(
    this.temperature,
    this.description
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFahrenheit = ref.watch(unitProvider);
    final temp = temperature;
    
    final displayTemp = isFahrenheit
        ? (temp * 9/5 + 32).toStringAsFixed(1)
        : temp.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$displayTemp°${isFahrenheit ? 'F' : 'C'}', 
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 3),
        Text(description, style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        )
      ],
    );
  }
}