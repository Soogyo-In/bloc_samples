import 'package:flutter/material.dart';

class WeatherPanel extends StatelessWidget {
  const WeatherPanel({
    super.key,
    this.weather = '--',
    this.temperature = 0.0,
    this.humidity = 0.0,
  });

  final String weather;

  final double temperature;

  final double humidity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(weather),
        Text('$temperature °C'),
        Text('$humidity %'),
      ],
    );
  }
}
