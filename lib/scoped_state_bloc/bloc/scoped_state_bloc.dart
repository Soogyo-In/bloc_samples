import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_samples/model/todo.dart';
import 'package:bloc_samples/repository/calender_repository.dart';
import 'package:bloc_samples/repository/memo_repository.dart';
import 'package:bloc_samples/repository/weather_repository.dart';
import 'package:equatable/equatable.dart';

part 'scoped_state_event.dart';
part 'scoped_state_state.dart';

class ScopedStateBloc extends Bloc<ScopedStateEvent, ScopedStateState> {
  ScopedStateBloc({
    required this.weatherRepository,
    required this.calenderRepository,
    required this.memoRepository,
  }) : super(ScopedStateState(
          calender: CalenderState(todosPerDate: []),
          memoList: MemoListState(memos: []),
          weather: const WeatherState(
            humidity: 0.0,
            temperature: 0.0,
            weather: '--',
          ),
        )) {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => add(ScopedStateEventWeatherTicked()),
    );

    on<ScopedStateEventInitialized>(_onInitialized);
    on<ScopedStateEventWeatherTicked>(_onWeatherTicked);
    on<ScopedStateEventMemoAdded>(_onMemoAdded);
    on<ScopedStateEventMemoConvertedToTodo>(_onMemoConvertedToTodo);
  }

  final WeatherRepository weatherRepository;

  final CalenderRepository calenderRepository;

  final MemoRepository memoRepository;

  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  FutureOr<void> _onInitialized(
    ScopedStateEventInitialized event,
    Emitter<ScopedStateState> emit,
  ) {
    emit(
      ScopedStateState(
        weather: WeatherState(
          weather: weatherRepository.weather,
          temperature: weatherRepository.temperature,
          humidity: weatherRepository.humidity,
        ),
        calender: CalenderState(
          todosPerDate: _organizeTodosByDate(calenderRepository.todos),
        ),
        memoList: MemoListState(memos: memoRepository.memos),
        initialized: true,
      ),
    );
  }

  FutureOr<void> _onWeatherTicked(
    ScopedStateEventWeatherTicked event,
    Emitter<ScopedStateState> emit,
  ) {
    emit(state.copyWith(
      weather: WeatherState(
        weather: weatherRepository.weather,
        temperature: weatherRepository.temperature,
        humidity: weatherRepository.humidity,
      ),
    ));
  }

  FutureOr<void> _onMemoAdded(
    ScopedStateEventMemoAdded event,
    Emitter<ScopedStateState> emit,
  ) {
    memoRepository.addMemo(event.memo);

    emit(ScopedStateStateMemoAdded(
      calender: state.calender,
      weather: state.weather,
      memoList: MemoListState(memos: memoRepository.memos),
    ));
  }

  FutureOr<void> _onMemoConvertedToTodo(
    ScopedStateEventMemoConvertedToTodo event,
    Emitter<ScopedStateState> emit,
  ) {
    calenderRepository.addTodo(
      group: event.group,
      title: event.memo,
    );
    memoRepository.removeMemo(event.memo);

    emit(ScopedStateStateCalender(
      weather: state.weather,
      memoList: MemoListState(memos: memoRepository.memos),
      calender: CalenderState(
        todosPerDate: _organizeTodosByDate(calenderRepository.todos),
      ),
    ));
  }

  List<List<Todo>> _organizeTodosByDate(List<Todo> todos) {
    final todosByDate = <DateTime, List<Todo>>{};
    for (final todo in todos) {
      todosByDate.update(
        DateTime(todo.date.year, todo.date.month, todo.date.day),
        (value) => value..add(todo),
        ifAbsent: () => [todo],
      );
    }
    return todosByDate.values.toList();
  }
}
