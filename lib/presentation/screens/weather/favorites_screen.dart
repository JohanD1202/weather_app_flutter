import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {

  static const name = "favorites-screen";

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Weather> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    favorites = await getFavorites();
    setState(() {});
  }

  void _removeFavorite(Weather weather) async {
    await toggleFavorite(weather);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos'),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w600
      ),),
      body: favorites.isEmpty
        ? Center(
          child: Text("Aún no tienes ciudades favoritas", 
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600
          )),
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
              onRemove: () =>_removeFavorite(weather)
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      children: [
        Text('${temperature.toStringAsFixed(1)}°C'),
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