import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/infrastructure/services/location/geolocation_service.dart';
import 'package:weather_app/presentation/providers/weather/current_location_provider.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_location_provider.dart';
import 'package:weather_app/presentation/screens/screens.dart';
import 'package:weather_app/presentation/widgets/shared/weather_bottom_navigation.dart';
import 'package:weather_app/presentation/widgets/weather/weather_background.dart';
import 'package:weather_app/presentation/widgets/weather/weather_secondary_information.dart';

/*final weather2 = Weather(
  city: "Tuluá",
  temperature: 18.0,
  description: "Lluvia ligera",
  feelsLike: 17.5,
  humidity: 85,
  windSpeed: 5.0,
  windDeg: 210,
  main: "",
  date: DateTime.now(),
  country: "Brazil",
  cloudiness: 0,
  pressure: 0
);*/


class HomeScreen extends StatefulWidget {

  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_selectedIndex != page) {
        setState(() {
          _selectedIndex = page;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: const [
          Placeholder(),
          _HomeView(),
          SavedScreen()
        ],
      ),
      bottomNavigationBar: WeatherBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped
      ),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  Map<String, double>? coords;
  final GeolocationService _geoService = GeolocationService();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      LocationPermission permission = await _geoService.checkPermission();

      if(permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if(mounted) {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Permiso de ubicación"),
              content: const Text(
                "Necesitamos acceder a tu ubicación para mostrar el clima actual.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Aceptar"),
                )
              ],
            ),
          );
        }
        permission = await _geoService.requestPermission(); 

        if(permission == LocationPermission.denied) {
          throw Exception('El usuario negó el permiso de ubicación.');
        } 

        if(permission == LocationPermission.deniedForever) {
          throw Exception(
            'El permiso está negado permanentemente. Habilítalo desde configuraciones.',
          );
        }
      }
      final position = await _geoService.getCurrentLocation();

      if(!mounted) return;
      setState(() {
        coords = {'lat': position.latitude, 'lon': position.longitude};
      });
      ref.read(currentLocationProvider.notifier).state = coords;
    } catch(e) {
      if(!mounted) return;

      setState(() {
        coords = {'lat': 3.42, 'lon': -76.52};
      });
      ref.read(currentLocationProvider.notifier).state = coords;
    }
  }


  @override
  Widget build(BuildContext context) {

    if(coords == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final weatherAsync = ref.watch(weatherByLocationProvider(coords!));
    return weatherAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error: $err")),
      data: (weather)  {
        return _WeatherInfo(weather);
      }
    );
  }
}

class _WeatherInfo extends StatelessWidget {

  final Weather weather;

  const _WeatherInfo(this.weather);

  @override
  Widget build(BuildContext context) {

    final countryFullName = countryNames[weather.country] ?? weather.country;

    return Stack(
        children: [
          WeatherBackground(weatherMain: weather.main),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 290),
                Text(weather.city,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w600
                )),
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
                Text(weather.description,
                style:  GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
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
              ]
            ),
          )
        ],
      );
  }
}