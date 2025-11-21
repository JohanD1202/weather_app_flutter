import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/presentation/providers/preferences/unit_provider.dart';

class WeatherTertiaryInformation extends ConsumerWidget {

  final int visibility;
  final double tempMin;
  final double tempMax;
  final int sunrise;
  final int sunset;
  final double windGust;
  final int timezone;

  const WeatherTertiaryInformation({
    super.key,
    required this.visibility,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
    required this.windGust,
    required this.timezone
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gustKmH = windGust * 3.6;
    final gustText = (windGust == 0.0)
      ? "N/A"
      : "${gustKmH.toStringAsFixed(1)} km/h";
    final isFahrenheit = ref.watch(unitProvider);

    final displayTempMin = isFahrenheit
        ? (tempMin * 9/5 + 32).toStringAsFixed(1)
        : tempMin.toStringAsFixed(1);
    
    final displayTempMax = isFahrenheit
        ? (tempMax * 9/5 + 32).toStringAsFixed(1)
        : tempMax.toStringAsFixed(1);


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
                  title: "Visibilidad",
                  value: formatVisibility(visibility),
                ),
                _InfoItem(
                  title: "Temp. min",
                  value: '$displayTempMin°${isFahrenheit ? 'F' : 'C'}',
                ),
                _InfoItem(
                  title: "Temp. max",
                  value: '$displayTempMax°${isFahrenheit ? 'F' : 'C'}',
                ),
              ],
            ),
            const SizedBox(height: 30),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  title: "Ráfaga",
                  value: gustText,
                ),
                _InfoItem(
                  title: "Amanecer",
                  value: formatSunTime(sunrise, timezone),
                ),
                _InfoItem(
                  title: "Atardecer",
                  value: formatSunTime(sunset, timezone),
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
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

String formatSunTime(int unix, int timezone) {
  final utcDate = DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: true);
  final localDate = utcDate.add(Duration(seconds: timezone));
  return DateFormat('hh:mm a').format(localDate);
}

String formatVisibility(int visibility) {
  if (visibility >= 1000) {
    final km = (visibility / 1000).toStringAsFixed(1);
    return "$km km";
  } else {
    return "$visibility m";
  }
}
