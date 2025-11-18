import 'package:flutter/material.dart';
import 'package:weather_app/domain/entities/weather.dart';

class WeatherDetailScreen extends StatelessWidget {

  static const name = 'weather-detail-screen';
  final Weather weather;

  const WeatherDetailScreen({
    super.key,
    required this.weather
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.city),
      ),
      body: Text('Termperatura: ${weather.temperature.toStringAsFixed(1)}'),
    );
  }
}