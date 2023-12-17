import 'dart:math';

class WeatherRepository {
  final _weathers = ['맑음', '흐림', '비', '눈'];

  final _temperatures = [26.4, 17.2, 10.8, -3.6];

  final _humidities = [30.0, 50.0, 70.0, 90.0];

  final _random = Random();

  String get weather => _weathers[_random.nextInt(4)];

  double get temperature => _temperatures[_random.nextInt(4)];

  double get humidity => _humidities[_random.nextInt(4)];
}
