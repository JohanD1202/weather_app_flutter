import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/presentation/providers/preferences/unit_provider.dart';

class WeatherSecondaryInformation extends ConsumerWidget {
  final double feelsLike;
  final double windSpeed;
  final int windDeg;
  final int humidity;
  final int cloudiness;
  final int pressure;

  const WeatherSecondaryInformation({
    super.key,
    required this.feelsLike,
    required this.windSpeed,
    required this.windDeg,
    required this.humidity,
    required this.cloudiness,
    required this.pressure
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final windSpeedKm = windSpeed * 3.6;
    final isFahrenheit = ref.watch(unitProvider);
    final temp = feelsLike;
    
    final displayTemp = isFahrenheit
        ? (temp * 9/5 + 32).toStringAsFixed(1)
        : temp.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  title: "Sensación",
                  value: '$displayTemp°${isFahrenheit ? 'F' : 'C'}',
                ),
                _InfoItem(
                  title: "Viento",
                  value: "${windSpeedKm.toStringAsFixed(1)} km/h",
                ),
                _InfoItem(
                  title: "Dirección",
                  value: windDirection(windDeg),
                ),
              ],
            ),
            const SizedBox(height: 30),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  title: "Humedad",
                  value: "$humidity%",
                ),
                _InfoItem(
                  title: "Nubosidad",
                  value: "$cloudiness%",
                ),
                _InfoItem(
                  title: "Presión",
                  value: "$pressure hPa",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

String windDirection(int deg) {
  if(deg >= 337 || deg < 23) return "Norte";
  if(deg >= 23 && deg < 68) return "Noreste";
  if(deg >= 68 && deg < 113) return "Este";
  if(deg >= 113 && deg < 158) return "Sureste";
  if(deg >= 158 && deg < 203) return "Sur";
  if(deg >= 203 && deg < 248) return "Suroeste";
  if(deg >= 248 && deg < 293) return "Oeste";
  if(deg >= 293 && deg < 337) return "Noroeste";

  return "N/A";
}

