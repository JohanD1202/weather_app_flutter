import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';
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

    final countryFullName = countryNames[weather.country] ?? weather.country;

    return Stack(
        children: [
          WeatherBackground(weatherMain: weather.main),
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
                    fontWeight: FontWeight.w600
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  ),
                ),
                Text(countryFullName, 
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                )),
                const SizedBox(height: 30),
                Text('${weather.temperature.toStringAsFixed(1)}°C',
                style: GoogleFonts.inter(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  height: 0.9,
                )),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(weather.description,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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