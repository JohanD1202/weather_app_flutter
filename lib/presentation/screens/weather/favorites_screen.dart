import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '/infrastructure/services/services.dart';
import '/presentation/widgets/widgets.dart';
import '/domain/domain.dart';
import '/config/config.dart';


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
      appBar: AppBar(
        centerTitle: false,
        title: const LocalizedText(
          translations: {
            "es": "Mis Favoritos",
            "en": "My Favorites"
          }
        ),
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
          ?
          Center(
            child: LocalizedText(
              translations: const {
                "es": "Aún no tienes ciudades favoritas",
                "en": "You don't have any favorite cities yet"
              },
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
        child: Row(
          children: [
            _InfoLocationCard(weather.city, weather.country),
            const Spacer(),
            _InfoTemperatureCard(weather.temperature, weather.description),
            const SizedBox(width: 5),
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
        LocalizedText(
          translations: countryNames[country] ??
          {"es": country, "en": country},
          style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500
        )),
      ],
    );
  }
}

class _InfoTemperatureCard extends StatelessWidget {

  final double temperature;
  final String description;

  const _InfoTemperatureCard(
    this.temperature,
    this.description
  );

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TemperatureText(
          celsius: temperature,
          style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 3),
        LocalizedText(
          translations: weatherDescriptions[description.toLowerCase()] ??
          {"es": description, "en": description},
          style: GoogleFonts.inter(
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