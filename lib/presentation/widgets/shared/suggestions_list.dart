import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/config/config.dart';
import '/domain/domain.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/providers/providers.dart';


class SuggestionsList extends ConsumerWidget {
  const SuggestionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final suggestionsAsync = ref.watch(citySuggestionProvider(query));

    final theme = Theme.of(context);
    final suggestionBg = theme.colorScheme.surface;
    final suggestionText = theme.textTheme.bodyLarge?.color;

    return suggestionsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox(),
      data: (cities) {
        if (cities.isEmpty) return const SizedBox();

        return Container(
          constraints: const BoxConstraints(maxHeight: 200),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: suggestionBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5),
            ],
          ),
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (_, i) {
              final city = cities[i];
              return _SuggestionTile(city: city, suggestionText: suggestionText);
            },
          ),
        );
      },
    );
  }
}

class _SuggestionTile extends ConsumerWidget {
  final City city;
  final Color? suggestionText;

  const _SuggestionTile({
    required this.city,
    this.suggestionText
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryTranslations = countryNames[city.country] ?? {
      "es": city.country,
      "en": city.country
    };

    return ListTile(
      title: LocalizedText(
        translations: {
          "es": "${city.name}, ${countryTranslations["es"]}",
          "en": "${city.name}, ${countryTranslations["en"]}",
        },
        style: TextStyle(color: suggestionText),
      ),
      subtitle:
          city.region.isNotEmpty
          ? Text(city.region)
          : const SizedBox(),
      onTap: () async => _onCitySelected(context, ref),
    );
  }

  Future<void> _onCitySelected(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);

    final exists = isCityAlreadyAdded(
      lat: city.lat,
      lon: city.lon,
      list: ref.read(searchedWeatherProvider),
    );

    if(exists) {
      final backgroundTheme = Theme.of(context).scaffoldBackgroundColor;
      messenger.showSnackBar(
        SnackBar(
          content: const LocalizedText(
            translations: {
              "es": "La ciudad ya está en la lista",
              "en": "The city is already on the list",
            },
          ),
          backgroundColor: backgroundTheme,
        ),
      );
      ref.read(searchQueryProvider.notifier).state = '';
      return;
    }
    final backgroundTheme = Theme.of(context).scaffoldBackgroundColor;

    await ref.read(weatherByCityProvider.notifier).searchByCoords(
          lat: city.lat,
          lon: city.lon,
        );
    final weather = ref.read(weatherByCityProvider).value;

    if(weather == null) {
      messenger.showSnackBar(
        SnackBar(
          content: const LocalizedText(
            translations: {
              "es": "No se pudo obtener el clima para esta ciudad",
              "en": "The weather for this city could not be obtained",
            },
          ),
          backgroundColor: backgroundTheme,
        ),
      );
      return;
    }

    final weatherWithCoords = weather.copyWith(
      id: weather.id,
      lat: city.lat,
      lon: city.lon,
      city: city.name,
    );

    ref.read(searchedWeatherProvider.notifier).addWeather(weatherWithCoords);
    ref.read(searchQueryProvider.notifier).state = '';
  }
}

bool isCityAlreadyAdded({
  required double lat,
  required double lon,
  required List<Weather> list,
}) {
  const epsilon = 0.00001;
  return list.any((w) =>
    (w.lat - lat).abs() < epsilon &&
    (w.lon - lon).abs() < epsilon
  );
}