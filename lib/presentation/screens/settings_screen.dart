import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/language_provider.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/theme_notifier_provider.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/unit_provider.dart';
import 'package:weather_app/presentation/widgets/shared/localized_text.dart';

class SettingsScreen extends StatelessWidget {

  static const name = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final styleTitle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 20
    );

    final styleIcon = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          translations: const {
            "es": "Ajustes",
            "en": "Settings"
          },
          style: styleTitle
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
            child: Icon(
              LucideIcons.arrowLeft,
              color: styleIcon,
            ),
            onTap: () => context.pop(),
          ),
      ),
    ),
    body: const _SettingsView(),
    );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final styleText = Theme.of(context).textTheme.bodyLarge;

    return ListView(
        children: [
          ListTile(
            title: LocalizedText(
              translations: const {
                "es": "Modo Oscuro",
                "en": "Dark Mode"
              },
              style: styleText
            ),
            trailing: Switch(
              value: ref.watch(themeProvider) == ThemeMode.dark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle()
            ),
          ),
          ListTile(
            title: LocalizedText(
              translations: const {
                "es": "Mostrar en Fahrenheit",
                "en": "Show in Fahrenheit"
              },
              style: styleText
            ),
            trailing: Switch(
              value: ref.watch(unitProvider),
              onChanged: (_) => ref.read(unitProvider.notifier).toggle()
            ),
          ),
          ListTile(
            title: LocalizedText(
              translations: const {
                "es": "Inglés",
                "en": "English"
              },
              style: styleText,
            ),
            trailing: Switch(
              value: ref.watch(languageProvider) == "en",
              onChanged: (_) => ref.read(languageProvider.notifier).toggle()
            ),
          ),
        ],
      );
  }
}