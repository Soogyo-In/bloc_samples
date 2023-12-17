part of 'weather_bloc.dart';

sealed class WeatherEvent {}

final class WeatherEventInitialized extends WeatherEvent {}

final class WeatherEventTicked extends WeatherEvent {}
