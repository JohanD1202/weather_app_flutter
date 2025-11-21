import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoItem extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? valueWidget;
  final String? value;

  const InfoItem({
    super.key,
    this.title,
    this.titleWidget,
    this.value,
    this.valueWidget,
  }) : assert(valueWidget != null || value != null, 'Debes pasar value o valueWidget');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleWidget ??
        Text(
          title!,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        valueWidget ??
        Text(
          value!,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}