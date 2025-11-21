import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/preferences/unit_provider.dart';

class CurrentLocationCard extends StatelessWidget {

  final Weather weather;

  const CurrentLocationCard({
    super.key,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
      child: SizedBox(
        height: 160,
        child: _Card(
          weatherMain: weather.main,
          weather: weather,
        )
      ),
    );
  }
}


class _Card extends ConsumerWidget {

  final String weatherMain;
  final Weather weather;

  const _Card({
    required this.weatherMain,
    required this.weather
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = _getColorsForWeather(weatherMain);
    final countryFullName = countryNames[weather.country] ?? weather.country;
    final isFahrenheit = ref.watch(unitProvider);
    final temp = weather.temperature;
    
    final displayTemp = isFahrenheit
        ? (temp * 9/5 + 32).toStringAsFixed(1)
        : temp.toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ImageCurrentLocationCard(weatherMain),
              const Spacer(),
              _InfoCurrentLocationCard(
                weather.city,
                countryFullName,
                weather.description,
              )
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(LucideIcons.mapPin, size: 20, color: Colors.lightBlue),
              ),
              const SizedBox(width: 5),
              Text("Mi Ubicación Actual",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black
              )),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('$displayTemp°${isFahrenheit ? 'F' : 'C'}', style: GoogleFonts.inter(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                )),
              ),
            ],
          )
          
        ],
      ),
    );
  }
}

class _ImageCurrentLocationCard extends StatelessWidget {

  final String weatherMain;

  const _ImageCurrentLocationCard(
    this.weatherMain
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          SizedBox(
            height: 115,
            width: 110,
            child: _buildSmallLottie(weatherMain),
          ),
        ],
      ),
    );
  }
}

class _InfoCurrentLocationCard extends StatelessWidget {

  final String city;
  final String country;
  final String description;

  const _InfoCurrentLocationCard(
    this.city,
    this.country,
    this.description,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(city, style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black
            )),
            const SizedBox(height: 3),
            Text(country, style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black

            )),
            const SizedBox(height: 10),
            Text(description, style:  GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black
            )),
        ],
      ),
    );
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

List<Color> _getColorsForWeather(String main) {
  main = main.toLowerCase();

  if(main.contains('clear')) {
    return const [
      Color.fromARGB(255, 65, 198, 242),
      Color.fromARGB(255, 39, 110, 203),
    ];
  }
  if(main.contains('clouds')) {
    return const [
      Color.fromARGB(255, 90, 97, 117),
        Color.fromARGB(255, 197, 197, 198),
    ];
  }
  if(main.contains('rain')) {
    return const [
      Color.fromARGB(255, 56, 70, 83),
      Color.fromARGB(255, 137, 137, 172),
    ];
  }
  if(main.contains('thunder') || main.contains('storm') || main.contains('thunderstorm')) {
    return const [
      Color.fromARGB(255, 1, 8, 98),
      Color.fromARGB(255, 92, 92, 197),
      Color.fromARGB(255, 190, 190, 225),
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

Widget _buildSmallLottie(String main) {
    main = main.toLowerCase();

    if(main.contains('rain') || main.contains('drizzle')) {
      return const _SmallLottie('assets/lottie/rain.json');
    }
    if(main.contains('clear')) {
      return const _SmallLottie('assets/lottie/clear.json');
    }
    if(main.contains('snow')) {
      return const _SmallLottie('assets/lottie/snow.json');
    }
    if(main.contains('thunder') ||
        main.contains('storm') ||
        main.contains('thunderstorm')) {
      return const _SmallLottie('assets/lottie/thunder.json');
    }
    if(main.contains('clouds')) {
      return const _SmallLottie('assets/lottie/clouds.json');
    }

    return const _SmallLottie('assets/lottie/clear.json');
  }