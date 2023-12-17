import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_samples/repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.weatherRepository)
      : super(const WeatherState(
          humidity: 0.0,
          temperature: 0.0,
          weather: '--',
        )) {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => add(WeatherEventTicked()),
    );

    on<WeatherEventInitialized>(_onInitialized);
    on<WeatherEventTicked>(_onTicked);
  }

  final WeatherRepository weatherRepository;

  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  FutureOr<void> _onInitialized(
    WeatherEventInitialized event,
    Emitter<WeatherState> emit,
  ) {
    emit(WeatherState(
      weather: weatherRepository.weather,
      temperature: weatherRepository.temperature,
      humidity: weatherRepository.humidity,
    ));
  }

  FutureOr<void> _onTicked(
    WeatherEventTicked event,
    Emitter<WeatherState> emit,
  ) {
    emit(WeatherState(
      weather: weatherRepository.weather,
      temperature: weatherRepository.temperature,
      humidity: weatherRepository.humidity,
    ));
  }
}
