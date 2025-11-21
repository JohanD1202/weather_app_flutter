import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/unit_provider.dart';

class TemperatureText extends ConsumerWidget {
  final double celsius;
  final TextStyle? style;

  const TemperatureText({
    super.key,
    required this.celsius,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFahrenheit = ref.watch(unitProvider);

    final temp = isFahrenheit
        ? (celsius * 9 / 5 + 32).toStringAsFixed(1)
        : celsius.toStringAsFixed(1);

    final unit = isFahrenheit ? 'F' : 'C';

    return Text(
      '$temp°$unit',
      style: style ?? GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
