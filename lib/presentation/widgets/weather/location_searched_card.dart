import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/config/constants/weather_descriptions.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/weather/searched_weather_provider.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';
import 'package:weather_app/presentation/widgets/shared/temperature_text.dart';

class LocationSearchedCard extends ConsumerWidget {
  final Weather weather;

  const LocationSearchedCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
      child: Dismissible(
        key: ValueKey('${weather.city}_${weather.country}_${weather.lat}_${weather.lon}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) {
          final textTheme = Theme.of(context);
          final backgroundTheme = Theme.of(context).scaffoldBackgroundColor;

          ref.read(searchedWeatherProvider.notifier).removeWeather(weather);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: LocalizedText(
                translations: {
                  "es": '${weather.city} eliminada',
                  "en": '${weather.city} deleted'
                },
                style: textTheme.textTheme.bodyLarge,
              ),
              backgroundColor: backgroundTheme,
            ),
          );
        },
        child: GestureDetector(
          onTap: () => context.push(
            '/weather-detail',
            extra: weather,
          ),
          child: _Card(
            weatherMain: weather.main,
            weather: weather,
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {

  final String weatherMain;
  final Weather weather;

  const _Card({
    required this.weatherMain,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoLocationCard(
            weather.city,
            weather.country,
          ),
          const Spacer(),
          _InfoTemperature(
            weather.temperature,
            weather.description,
          )
        ],
      ),
    );
  }
}

class _InfoLocationCard extends StatelessWidget {

  final String city;
  final String country;

  const _InfoLocationCard(
    this.city,
    this.country,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 12, bottom: 15),
      child: Column(
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
      ),
    );
  }
}

class _InfoTemperature extends StatelessWidget {
  
  final double temperature;
  final String description;

  const _InfoTemperature(
    this.temperature,
    this.description,
  );

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TemperatureText(
            celsius: temperature,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            )
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 100,
            child: LocalizedText(
              translations: weatherDescriptions[description.toLowerCase()] ??
              {"es": description, "en": description},
              style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

