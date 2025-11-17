import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/presentation/widgets/widgets.dart';

class WeatherBackground extends StatelessWidget {
  final String weatherMain;

  const WeatherBackground({
    super.key,
    required this.weatherMain
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsForWeather(weatherMain);

    return LinearGradientSeason(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      child: _buildLottie(),
    );
  }

  List<Color> _getColorsForWeather(String main) {
    main = main.toLowerCase();

    if(main.contains('clear')) {
      return [
        Color.fromARGB(255, 65, 198, 242),
        Color.fromARGB(255, 39, 110, 203),
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
        Color.fromARGB(255, 56, 70, 83),
        Color.fromARGB(255, 137, 137, 172),
      ];
    }
    if(main.contains('thunder') || main.contains('storm')
    || main.contains('thunderstorm')) {
      return [
        Color.fromARGB(255, 1, 8, 98),
        Color.fromARGB(255, 92, 92, 197),
        Color.fromARGB(255, 190, 190, 225),
      ];
    }
    if(main.contains('snow')) {
      return [
        Color(0xFFe6dada),
        Color.fromARGB(255, 66, 123, 143),
        Color.fromARGB(255, 43, 78, 86),
      ];
    }
    return [        
      Color.fromARGB(255, 65, 198, 242),
        Color.fromARGB(255, 39, 110, 203),
    ];
  }

  Widget _buildLottie() {
    if(weatherMain.toLowerCase().contains('rain') || 
    weatherMain.toLowerCase().contains('drizzle')) {
      return _LottieImage('assets/lottie/rain.json');
    } 
    if(weatherMain.toLowerCase().contains('clear')) {
      return _LottieImage('assets/lottie/clear.json');
    }
    if(weatherMain.toLowerCase().contains('snow')) {
      return _LottieImage('assets/lottie/snow.json');
    }
    if(weatherMain.toLowerCase().contains('thunder')
    || weatherMain.toLowerCase().contains('storm')
    || weatherMain.toLowerCase().contains('thunderstorm')) {
      return _LottieImage('assets/lottie/thunder.json');
    }
    if(weatherMain.toLowerCase().contains('clouds')) {
      return _LottieImage('assets/lottie/clouds.json');
    }
    return _LottieImage('assets/lottie/clear.json');
  }
}

class _LottieImage extends StatelessWidget {

  final String name;

  const _LottieImage(
    this.name
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 100),
        Center(
          child: Lottie.asset(
            name,
            fit: BoxFit.cover,
            repeat: true
          ),
        )
      ],
    );
  }
}

