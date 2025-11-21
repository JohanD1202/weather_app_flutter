import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/config/constants/country_names.dart';
import 'package:weather_app/presentation/providers/suggestions/city_suggestion_provider.dart';
import 'package:weather_app/presentation/providers/suggestions/search_query_provider.dart';
import 'package:weather_app/presentation/providers/weather/current_location_provider.dart';
import 'package:weather_app/presentation/providers/weather/is_refreshing_provider.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_city.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_location_provider.dart';
import 'package:weather_app/presentation/providers/weather/searched_weather_provider.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';
import 'package:weather_app/presentation/widgets/weather/current_location_card.dart';
import 'package:weather_app/presentation/widgets/shared/custom_appbar.dart';
import 'package:weather_app/presentation/widgets/weather/location_searched_card.dart';

class SearchScreen extends StatelessWidget {
  static const name = "saved-screen";
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(95),
        child: CustomAppbar(),
      ),
      body: _BodySavedScreen()
    );
  }
}

class _BodySavedScreen extends ConsumerWidget {
  const _BodySavedScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final coords = ref.watch(currentLocationProvider);

    if(coords == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final weatherAsync = ref.watch(weatherByLocationProvider(coords));
    final searchedWeatherList = ref.watch(searchedWeatherProvider);
    final query = ref.watch(searchQueryProvider);
    final suggestionsAsync = ref.watch(citySuggestionProvider(query));
    final isRefreshing = ref.watch(isRefreshingProvider);
    final theme = Theme.of(context);
    final suggestionBg = theme.colorScheme.surface;
    final suggestionText = theme.textTheme.bodyLarge?.color;

    
    return Column(
        children: [
          suggestionsAsync.when(
            data: (cities) {
              if(cities.isEmpty) return const SizedBox();
              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: suggestionBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: cities.length,
                  itemBuilder: (_, i) {
                    final city = cities[i];

                    final countryTranslations = countryNames[city.country] ?? {
                      "es": city.country,
                      "en": city.country
                    };

                    return ListTile(
                      title: LocalizedText(
                        translations: {
                          "es": "${city.name}, ${countryTranslations["es"]}",
                          "en": "${city.name}, ${countryTranslations["en"]}"
                        },
                        style: TextStyle(color: suggestionText),
                        ),
                        subtitle: city.state != null
                          ? Text(city.state!)
                          : const Text(""),
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          FocusScope.of(context).unfocus();

                          final cityNameNormalized = city.name.trim().toLowerCase();
                          final countryNormalized = city.country.trim().toLowerCase();

                          final existingList = ref.read(searchedWeatherProvider);
                          final exists = existingList.any(
                            (w) =>
                              w.city.trim().toLowerCase() == cityNameNormalized &&
                              w.country.trim().toLowerCase() == countryNormalized,
                          );

                          if(exists) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text("La ciudad ya está en la lista")),
                            );
                            ref.read(searchQueryProvider.notifier).state = '';
                            return; // salir antes de hacer la búsqueda
                          }

                          await ref.read(weatherByCityProvider.notifier).search(city.name);
                          final weather = ref.read(weatherByCityProvider).value;
                          if (weather != null) {
                            ref.read(searchedWeatherProvider.notifier).addWeather(weather);
                          }

                          ref.read(searchQueryProvider.notifier).state = '';
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
            error: (_, __) => const SizedBox(),
          ),
          Expanded(
            child: weatherAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
              data: (currentWeather) {
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    CurrentLocationCard(weather: currentWeather),
                    if(isRefreshing) const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    )
                    else
                    ...searchedWeatherList.map(
                      (weather) => LocationSearchedCard(weather: weather),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
  }
}
