import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/language_provider.dart';
import 'package:weather_app/presentation/providers/suggestions/search_query_provider.dart';
import 'package:weather_app/presentation/providers/weather/is_refreshing_provider.dart';
import 'package:weather_app/presentation/providers/weather/weather_by_city.dart';
import 'package:weather_app/presentation/providers/weather/searched_weather_provider.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final iconColor = Theme.of(context).iconTheme.color;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: SizedBox(
                    height: 50,
                    child: _TextField(),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(LucideIcons.refreshCcw),
                  color: iconColor,
                  onPressed: () async {
                    ref.read(isRefreshingProvider.notifier).state = true;
                    await ref.read(searchedWeatherProvider.notifier).refresh(ref);
                    ref.read(isRefreshingProvider.notifier).state = false;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends ConsumerWidget {
  const _TextField();

  void _onQueryChanged(String value, WidgetRef ref) {
    ref.read(searchQueryProvider.notifier).state = value;
  }

  Future<void> _onSubmitted(
    String value,
    WidgetRef ref,
    BuildContext context,
  ) async {

    final textTheme = Theme.of(context);
    final backgroundTheme = Theme.of(context).scaffoldBackgroundColor;

    final query = value.trim();
    if (query.isEmpty) return;
  
    final messenger = ScaffoldMessenger.of(context);
  
    try {
      // Buscar el clima de la ciudad
      await ref.read(weatherByCityProvider.notifier).search(query);
      final weather = ref.read(weatherByCityProvider).value;
      if (weather == null) throw Exception();
  
      // Verificar duplicados por ciudad + país
      final existingList = ref.read(searchedWeatherProvider);
      final exists = existingList.any(
        (w) =>
            w.city.trim().toLowerCase() == weather.city.trim().toLowerCase() &&
            w.country.trim().toLowerCase() == weather.country.trim().toLowerCase(),
      );
  
      if (exists) {
        messenger.showSnackBar(
          SnackBar(
            content: LocalizedText(
              translations: const  {
                "es": "La ciudad ya está en la lista",
                "en": "The city is already on the list"
              },
              style: textTheme.textTheme.bodyLarge,
            ),
            backgroundColor: backgroundTheme,
          ),
        );
        return;
      }
  
      // Agregar la ciudad
      ref.read(searchedWeatherProvider.notifier).addWeather(weather);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: LocalizedText(
            translations: const {
              "es": "Ciudad no encontrada",
              "en": "City not found"
            },
            style: textTheme.textTheme.bodyLarge,
          ),
          backgroundColor: backgroundTheme,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final lang = ref.watch(languageProvider);
    final hint = {
      "es": "Ingrese el nombre de la ciudad",
      "en": "Enter the city name",
    }[lang] ?? "Enter the city name";

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final hintColor = Theme.of(context).hintColor;
    final iconColor = Theme.of(context).iconTheme.color;

    final theme = Theme.of(context);
    final fillColor = theme.colorScheme.surface;

    return TextField(
      onChanged: (value) => _onQueryChanged(value, ref),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          LucideIcons.search,
          color: iconColor,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onSubmitted:(value) => _onSubmitted(value, ref, context)
    );
  }
}