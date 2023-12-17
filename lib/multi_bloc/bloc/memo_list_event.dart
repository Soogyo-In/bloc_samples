part of 'memo_list_bloc.dart';

sealed class MemoListEvent {}

final class MemoListEventAdded extends MemoListEvent {
  MemoListEventAdded(this.memo);

  final String memo;
}

final class MemoListEventConvertedToTodo extends MemoListEvent {
  MemoListEventConvertedToTodo({required this.group, required this.memo});

  final String group;

  final String memo;
}
