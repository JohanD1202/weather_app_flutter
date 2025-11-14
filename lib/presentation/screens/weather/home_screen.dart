import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/providers/providers.dart';

class HomeScreen extends StatelessWidget {

  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  final String defaultCity = "Tuluá";
  
  @override
  Widget build(BuildContext context) {

    final weatherAsync = ref.watch(weatherProvider(defaultCity));

    return weatherAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text("Error: $err"),
      ),

    data: (weather) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(weather.city, style: TextStyle(fontSize: 30),)),
          Text("${weather.temperature} °C", style: TextStyle(fontSize: 30)),
          Text(weather.description, style: TextStyle(fontSize: 30))
      ],
    )
    );
  }
}