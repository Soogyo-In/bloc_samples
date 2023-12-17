part of 'scoped_state_bloc.dart';

sealed class ScopedStateEvent {}

final class ScopedStateEventInitialized extends ScopedStateEvent {}

final class ScopedStateEventWeatherTicked extends ScopedStateEvent {}

final class ScopedStateEventMemoAdded extends ScopedStateEvent {
  ScopedStateEventMemoAdded(this.memo);

  final String memo;
}

final class ScopedStateEventMemoConvertedToTodo extends ScopedStateEvent {
  ScopedStateEventMemoConvertedToTodo({
    required this.group,
    required this.memo,
  });

  final String group;

  final String memo;
}
