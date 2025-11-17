import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/providers/weather/current_location_provider.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_location_provider.dart';
import 'package:weather_app/presentation/widgets/weather/current_location_card.dart';
import 'package:weather_app/presentation/widgets/shared/custom_appbar.dart';

class SavedScreen extends ConsumerWidget {
  static const name = "saved-screen";
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final coords = ref.watch(currentLocationProvider);

    if (coords == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final weatherAsync = ref.watch(weatherByLocationProvider(coords));

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppbar(),
      ),
      body: weatherAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (weather) {
          return ListView(
            children: [
              CurrentLocationCard(
                weatherMain: weather.main,
                weather: weather,
              ),
            ],
          );
        },
      ),
    );
  }
}