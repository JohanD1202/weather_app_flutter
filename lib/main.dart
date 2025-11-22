import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/config/router/app_router.dart';
import 'package:weather_app/config/theme/app_theme.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/theme_notifier_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: MainApp()
    )
  );
}

final themeNotifier = ThemeNotifier();
final appTheme = AppTheme();

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.lightTheme(),
      darkTheme: appTheme.darkTheme(),
      themeMode: currentMode,
    );
  }
}


