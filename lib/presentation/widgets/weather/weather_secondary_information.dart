import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/language_provider.dart';
import 'package:weather_app/presentation/widgets/shared/info_item.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';
import 'package:weather_app/presentation/widgets/shared/temperature_text.dart';

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
    final colorBackground = Theme.of(context).colorScheme.surface;
    final lang = ref.watch(languageProvider);
    final TextStyle styleText = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Sensación",
                      "en": "Feels Like"
                    },
                    style: styleText
                  ),
                  valueWidget: TemperatureText(
                    celsius: feelsLike,
                  )
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "V. Viento",
                      "en": "S. Wind"
                    },
                    style: styleText
                  ),
                  value: "${windSpeedKm.toStringAsFixed(1)} km/h",
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "D. Viento",
                      "en": "D. Wind"
                    },
                    style: styleText
                  ),
                  value: windDirection(windDeg, lang),
                ),
              ],
            ),
            const SizedBox(height: 30),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Humedad",
                      "en": "Humidity"
                    },
                    style: styleText
                  ),
                  value: "$humidity%",
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Nubosidad",
                      "en": "Cloudiness"
                    },
                    style: styleText
                  ),
                  value: "$cloudiness%",
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Presión",
                      "en": "Pressure"
                    },
                    style: styleText
                  ),
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

String windDirection(int deg, String lang) {
  final directionsEs = {
    "N": "Norte",
    "NE": "Noreste",
    "E": "Este",
    "SE": "Sureste",
    "S": "Sur",
    "SW": "Suroeste",
    "W": "Oeste",
    "NW": "Noroeste",
  };

  final directionsEn = {
    "N": "North",
    "NE": "Northeast",
    "E": "East",
    "SE": "Southeast",
    "S": "South",
    "SW": "Southwest",
    "W": "West",
    "NW": "Northwest",
  };

  String code;

  if (deg >= 337 || deg < 23) {
    code = "N";
  } else if (deg >= 23 && deg < 68) {
    code = "NE";
  } else if (deg >= 68 && deg < 113) {
    code = "E";
  } else if (deg >= 113 && deg < 158) {
    code = "SE";
  } else if (deg >= 158 && deg < 203) {
    code = "S";
  } else if (deg >= 203 && deg < 248) {
    code = "SW";
  } else if (deg >= 248 && deg < 293) {
    code = "W";
  } else if (deg >= 293 && deg < 337) {
    code = "NW";
  } else {
    code = "N";
  }

  return lang == "es"
      ? directionsEs[code]!
      : directionsEn[code]!;
}



