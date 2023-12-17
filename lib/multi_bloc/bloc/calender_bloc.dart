import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_samples/model/todo.dart';
import 'package:bloc_samples/repository/calender_repository.dart';

part 'calender_event.dart';
part 'calender_state.dart';

class CalenderBloc extends Bloc<CalenderEvent, CalenderState> {
  CalenderBloc(this.calenderRepository)
      : super(CalenderState(todosPerDate: [], initialized: true)) {
    on<CalenderEventInitialized>(_onInitialized);
    on<CalenderEventUpdated>(_onUpdated);
  }

  final CalenderRepository calenderRepository;

  FutureOr<void> _onInitialized(
    CalenderEventInitialized event,
    Emitter<CalenderState> emit,
  ) {
    emit(CalenderState(
      todosPerDate: _organizeTodosByDate(calenderRepository.todos),
      initialized: true,
    ));
  }

  FutureOr<void> _onUpdated(
    CalenderEventUpdated event,
    Emitter<CalenderState> emit,
  ) {
    emit(CalenderState(
      todosPerDate: _organizeTodosByDate(calenderRepository.todos),
      initialized: true,
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
