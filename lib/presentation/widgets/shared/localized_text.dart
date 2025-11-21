import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/infrastructure/services/shared_preferences/language_provider.dart';

class LocalizedText extends ConsumerWidget {
  final Map<String, String> translations;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText({
    super.key,
    required this.translations,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final text = translations[lang] ?? translations.values.first;

    return Text(
      text,
      style: style ?? GoogleFonts.inter(
        fontSize: 20,
        color: Theme.of(context).textTheme.bodyLarge?.color
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
