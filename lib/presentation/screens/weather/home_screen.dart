import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/widgets/widgets.dart';
import '/infrastructure/services/services.dart';
import '/presentation/providers/providers.dart';

class HomeScreen extends StatefulWidget {
  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  Map<String, double>? coords;
  bool _dialogShown = false;
  final GeolocationService _geoService = GeolocationService();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final position = await _geoService.determinePosition();

      if (!mounted) return;
      setState(() {
        coords = {
          'lat': position.latitude,
          'lon': position.longitude,
        };
      });

      ref.read(currentLocationProvider.notifier).state = coords;
    } catch (_) {
      if (!mounted) return;

      setState(() {
        coords = {'lat': 3.42, 'lon': -76.52};
      });
      ref.read(currentLocationProvider.notifier).state = coords;
    }
  }

  void _showNoInternetDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    final textTheme = Theme.of(context);
    final backgroundTheme = Theme.of(context).scaffoldBackgroundColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: backgroundTheme,
          title: LocalizedText(
            translations: const {
              "es": "Sin conexión a internet",
              "en": "Without internet connection"
            },
            style: textTheme.textTheme.bodyLarge,
          ),
          content: LocalizedText(
            translations: const {
              "es": "Necesitas una conexión a internet para usar nuestra app.",
              "en": "You need an internet connection to use our app."
            },
            style: textTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                _dialogShown = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _retryConnectivity();
                });
              },
              child: LocalizedText(
                translations: const {
                  "es": "Reintentar",
                  "en": "Retry"
                },
                style: textTheme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                _dialogShown = false;
                SystemNavigator.pop();
              },
              child: const LocalizedText(
                translations: {
                  "es": "Salir",
                  "en": "Go out"
                },
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _retryConnectivity() {
    final connectivity = ref.read(connectivityStatusProvider).value;
    if (connectivity == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(connectivityStatusProvider).maybeWhen(
          data: (status) => status,
          orElse: () => ConnectivityResult.wifi,
        );

    final isOffline = connectivity == ConnectivityResult.none;

    if (isOffline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoInternetDialog();
      });
    }

    if (coords == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isOffline) {
      return const SizedBox();
    }

    final weatherAsync = ref.watch(weatherByLocationProvider(coords!));

    return weatherAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => const Center(
        child: Text(
          "Error al obtener datos",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
      data: (weather) {
        return WeatherInfo(weather: weather);
      },
    );
  }
}
