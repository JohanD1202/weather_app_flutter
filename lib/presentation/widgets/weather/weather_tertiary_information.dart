import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/presentation/widgets/shared/info_item.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';
import 'package:weather_app/presentation/widgets/shared/temperature_text.dart';

class WeatherTertiaryInformation extends StatelessWidget {

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
  Widget build(BuildContext context) {

    final gustKmH = windGust * 3.6;
    final gustText = (windGust == 0.0)
      ? "N/A"
      : "${gustKmH.toStringAsFixed(1)} km/h";
    final colorBackground = Theme.of(context).colorScheme.surface;
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
                      "es": "Visibilidad",
                      "en": "Visibility"
                    },
                    style: styleText
                  ),
                  value: formatVisibility(visibility),
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Temp. min",
                      "en": "Min. Temp"
                    },
                    style: styleText
                  ),
                  valueWidget: TemperatureText(
                    celsius: tempMin
                  ),
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Temp. max",
                      "en": "Max. Temp"
                    },
                    style: styleText
                  ),
                  valueWidget: TemperatureText(
                    celsius: tempMax
                  ),
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
                      "es": "Ráfaga",
                      "en": "Burst"
                    },
                    style: styleText
                  ),
                  value: gustText,
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Amanecer",
                      "en": "Sunrise"
                    },
                    style: styleText
                  ),
                  value: formatSunTime(sunrise, timezone),
                ),
                InfoItem(
                  titleWidget: LocalizedText(
                    translations: const {
                      "es": "Atardecer",
                      "en": "Sunset"
                    },
                    style: styleText
                  ),
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
