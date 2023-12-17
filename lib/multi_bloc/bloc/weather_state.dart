part of 'weather_bloc.dart';

class WeatherState {
  const WeatherState({
    required this.weather,
    required this.temperature,
    required this.humidity,
  });

  final String weather;

  final double temperature;

  final double humidity;
}
