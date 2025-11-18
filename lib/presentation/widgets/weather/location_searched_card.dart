import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';

class LocationSearchedCard extends StatelessWidget {

  final Weather weather;

  const LocationSearchedCard({
    super.key,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
      child: SizedBox(
        height: 90,
        child: GestureDetector(
          onTap: () => context.push(
            '/weather-detail',
            extra: weather
          ),
          child: _Card(
            weatherMain: weather.main,
            weather: weather,
          ),
        )
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

    final countryFullName = countryNames[weather.country] ?? weather.country;

    return Card(
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoLocationCard(
            weather.city,
            countryFullName,
            weather.description,
            weather.temperature
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
  final String description;
  final double temperature;

  const _InfoLocationCard(
    this.city,
    this.country,
    this.description,
    this.temperature
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(city, style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600
          )),
          const SizedBox(height: 10),
          Text(country, style: GoogleFonts.inter(
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
          Text('${temperature.toStringAsFixed(1)}°C', style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 5),
          SizedBox(
            width: 100,
            child: Text(description, style:  GoogleFonts.inter(
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

