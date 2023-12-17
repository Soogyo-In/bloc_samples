part of 'calender_bloc.dart';

class CalenderState {
  CalenderState({
    required this.todosPerDate,
    required this.initialized,
  });

  final List<List<Todo>> todosPerDate;

  final bool initialized;
}
