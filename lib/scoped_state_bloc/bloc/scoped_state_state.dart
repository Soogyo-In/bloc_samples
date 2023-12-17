part of 'scoped_state_bloc.dart';

class WeatherState extends Equatable {
  const WeatherState({
    required this.weather,
    required this.temperature,
    required this.humidity,
  });

  final String weather;

  final double temperature;

  final double humidity;

  @override
  List<Object?> get props => [weather, temperature, humidity];
}

class CalenderState extends Equatable {
  const CalenderState({required this.todosPerDate});

  final List<List<Todo>> todosPerDate;

  @override
  List<Object?> get props => [todosPerDate];
}

class MemoListState extends Equatable {
  const MemoListState({required this.memos});

  final List<String> memos;

  @override
  List<Object?> get props => [memos];
}

class ScopedStateState {
  const ScopedStateState({
    required this.weather,
    required this.calender,
    required this.memoList,
    this.initialized = false,
  });

  final WeatherState weather;

  final CalenderState calender;

  final MemoListState memoList;

  final bool initialized;

  ScopedStateState copyWith({
    WeatherState? weather,
    CalenderState? calender,
    MemoListState? memoList,
  }) =>
      ScopedStateState(
        weather: weather ?? this.weather,
        calender: calender ?? this.calender,
        memoList: memoList ?? this.memoList,
      );
}

class ScopedStateStateCalender extends ScopedStateState {
  const ScopedStateStateCalender({
    required super.weather,
    required super.calender,
    required super.memoList,
  }) : super(initialized: false);
}

class ScopedStateStateMemoAdded extends ScopedStateState {
  const ScopedStateStateMemoAdded({
    required super.weather,
    required super.calender,
    required super.memoList,
  }) : super(initialized: false);
}
