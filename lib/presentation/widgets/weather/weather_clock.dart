import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherClock extends StatefulWidget {
  final int timezone;

  const WeatherClock({
    super.key,
    required this.timezone,
  });

  @override
  State<WeatherClock> createState() => _WeatherClockState();
}

class _WeatherClockState extends State<WeatherClock> {
  late DateTime currentDate;
  late final Timer timer;

  @override
  void initState() {
    super.initState();

    // La hora actual REAL del mundo + timezone del país
    currentDate = DateTime.now().toUtc().add(
      Duration(seconds: widget.timezone),
    );

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        currentDate = currentDate.add(const Duration(seconds: 1));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = 
      '${currentDate.hour.toString().padLeft(2,'0')}:' 
      '${currentDate.minute.toString().padLeft(2,'0')}';

    return Text(
      formattedDate,
      style: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
