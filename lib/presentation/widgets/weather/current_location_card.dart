import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';

class CurrentLocationCard extends StatelessWidget {

  final String weatherMain;
  final Weather weather;

  const CurrentLocationCard({
    super.key,
    required this.weatherMain,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
      child: SizedBox(
        height: 160,
        child: _GradientCard(
          weatherMain: weatherMain,
          weather: weather,
        )
      ),
    );
  }
}

List<Color> _getColorsForWeather(String main) {
  main = main.toLowerCase();

  if(main.contains('clear')) {
    return [
      const Color.fromARGB(255, 65, 198, 242),
      const Color.fromARGB(255, 39, 110, 203),
    ];
  }
  if(main.contains('clouds')) {
    return [
      Color.fromARGB(255, 90, 97, 117),
        Color.fromARGB(255, 197, 197, 198),
    ];
  }
  if(main.contains('rain')) {
    return [
      const Color.fromARGB(255, 56, 70, 83),
      const Color.fromARGB(255, 137, 137, 172),
    ];
  }
  if(main.contains('thunder') || main.contains('storm') || main.contains('thunderstorm')) {
    return [
      const Color.fromARGB(255, 1, 8, 98),
      const Color.fromARGB(255, 92, 92, 197),
      const Color.fromARGB(255, 190, 190, 225),
    ];
  }
  if(main.contains('snow')) {
    return [
      const Color(0xFFe6dada),
      const Color.fromARGB(255, 66, 123, 143),
      const Color.fromARGB(255, 43, 78, 86),
    ];
  }

  return [
    const Color.fromARGB(255, 65, 198, 242),
    const Color.fromARGB(255, 39, 110, 203),
  ];
}


class _GradientCard extends StatelessWidget {

  final String weatherMain;
  final Weather weather;

  const _GradientCard({
    required this.weatherMain,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {

    final weatherMain = weather.main;
    final colors = _getColorsForWeather(weatherMain);
    final countryFullName = countryNames[weather.country] ?? weather.country;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 115,
                  width: 120,
                  child: _buildSmallLottie(weatherMain),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.mapPin, size: 20, color: Colors.lightBlue),
                    const SizedBox(width: 5),
                    Text("Mi Ubicación Actual",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    )),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(weather.city,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  )),
                  const SizedBox(height: 3),
                  Text(countryFullName, 
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  )),
                  const SizedBox(height: 10),
                  Text(weather.description,
                  style:  GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  )),
                  const SizedBox(height: 8),
                  Text('${weather.temperature.toStringAsFixed(1)}°C',
                  style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---- LOTTIE PEQUEÑO ----
  Widget _buildSmallLottie(String main) {
    main = main.toLowerCase();

    if (main.contains('rain') || main.contains('drizzle')) {
      return _SmallLottie('assets/lottie/rain.json');
    }
    if (main.contains('clear')) {
      return _SmallLottie('assets/lottie/clear.json');
    }
    if (main.contains('snow')) {
      return _SmallLottie('assets/lottie/snow.json');
    }
    if (main.contains('thunder') ||
        main.contains('storm') ||
        main.contains('thunderstorm')) {
      return _SmallLottie('assets/lottie/thunder.json');
    }
    if (main.contains('clouds')) {
      return _SmallLottie('assets/lottie/clouds.json');
    }

    return _SmallLottie('assets/lottie/clear.json');
  }
}

class _SmallLottie extends StatelessWidget {
  final String asset;

  const _SmallLottie(this.asset);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      fit: BoxFit.contain,
      repeat: true,
    );
  }
}
