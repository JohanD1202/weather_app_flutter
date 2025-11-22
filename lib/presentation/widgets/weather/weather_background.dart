import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/presentation/widgets/widgets.dart';

class WeatherBackground extends StatelessWidget {
  final String weatherMain;
  final int timezone;

  const WeatherBackground({
    super.key,
    required this.weatherMain,
    required this.timezone
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

  bool isNight() {
    final now = DateTime.now().toUtc().add(
      Duration(seconds: timezone),
    );

    final hour = now.hour;

    // Entre 6pm y 6am = noche
    return hour < 6 || hour >= 18;
  }

  List<Color> _getColorsForWeather(String main) {
    final night = isNight();
    main = main.toLowerCase();

    if(main.contains('clear')) {
      return night 
      ? [
        const Color.fromARGB(255, 8, 2, 173),
        const Color.fromARGB(255, 47, 152, 250),
      ]
      : [
        const Color.fromARGB(255, 65, 198, 242),
        const Color.fromARGB(255, 39, 110, 203),
      ];
    }
    if(main.contains('clouds')) {
      return [
        const Color.fromARGB(255, 90, 97, 117),
        const Color.fromARGB(255, 197, 197, 198),
      ];
    }
    if((main.contains('rain')) || main.contains('drizzle')) {
      return [
        const Color.fromARGB(255, 56, 70, 83),
        const Color.fromARGB(255, 137, 137, 172),
      ];
    }
    if(main.contains('thunder') || main.contains('storm')
    || main.contains('thunderstorm')) {
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
    if(main.contains('mist') || main.contains('haze')
    || main.contains('fog') || main.contains('smoke')) {
      return [
      const Color.fromARGB(255, 63, 63, 63),
      const Color.fromARGB(255, 144, 145, 145)
      ];
    }
    return [        
      const Color.fromARGB(255, 65, 198, 242),
      const Color.fromARGB(255, 39, 110, 203),
    ];
  }

  Widget _buildLottie() {

    final night = isNight();
    final main = weatherMain.toLowerCase();

    if(main.contains('rain') || main.contains('drizzle')) {
      return const _LottieImage('assets/lottie/rain.json');
    } 
    if(main.contains('clear')) {
      return night
        ? const _LottieImage('assets/lottie/night.json')
        : const _LottieImage('assets/lottie/clear.json');
    }
    if(main.contains('snow')) {
      return const _LottieImage('assets/lottie/snow.json');
    }
    if(main.contains('thunder')
    || main.contains('storm')
    || main.contains('thunderstorm')) {
      return const _LottieImage('assets/lottie/thunder.json');
    }
    if(main.contains('clouds')) {
      return const _LottieImage('assets/lottie/clouds.json');
    }
    if(main.contains('mist')
    || main.contains('haze')
    || main.contains('fog')
    || main.contains('smoke')) {
      return const _LottieImage('assets/lottie/mist.json');
    }
    return const _LottieImage('assets/lottie/clear.json');
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
        const SizedBox(height: 100),
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

