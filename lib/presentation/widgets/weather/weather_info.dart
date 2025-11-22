import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/config/constants/weather_descriptions.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';
import 'package:weather_app/presentation/widgets/shared/temperature_text.dart';
import 'package:weather_app/presentation/widgets/weather/weather_background.dart';
import 'package:weather_app/presentation/widgets/weather/weather_clock.dart';
import 'package:weather_app/presentation/widgets/weather/weather_secondary_information.dart';
import 'package:weather_app/presentation/widgets/weather/weather_tertiary_information.dart';

class WeatherInfo extends StatelessWidget {

  final Weather weather;

  const WeatherInfo({
    required this.weather,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        WeatherBackground(
          weatherMain: weather.main,
          timezone: weather.timezone,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: WeatherClock(
                  timezone: weather.timezone,
                )
              ),
              const SizedBox(height: 150),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(weather.city,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                ),
              ),
              LocalizedText(
                translations: countryNames[weather.country] ??
                {"es": weather.country, "en": weather.country},
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
              )),
              const SizedBox(height: 30),
              TemperatureText(
                celsius: weather.temperature,
                style: GoogleFonts.inter(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  height: 0.9,
                  color: Colors.black
                )
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: LocalizedText(
                  translations: weatherDescriptions[weather.description.toLowerCase()] ??
                  {"es": weather.description, "en": weather.description},
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 35),
              WeatherSecondaryInformation(
                feelsLike: weather.feelsLike,
                windSpeed: weather.windSpeed,
                windDeg: weather.windDeg,
                humidity: weather.humidity,
                cloudiness: weather.cloudiness,
                pressure: weather.pressure,
              ),
              const SizedBox(height: 30),
              WeatherTertiaryInformation(
                visibility: weather.visibility,
                tempMin: weather.tempMin,
                tempMax: weather.tempMax,
                sunrise: weather.sunrise,
                sunset: weather.sunset,
                windGust: weather.windGust,
                timezone: weather.timezone,
              ),
              const SizedBox(height: 30),
            ]
          ),
        )
      ],
    );
  }
}