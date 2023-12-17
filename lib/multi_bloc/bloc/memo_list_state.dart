part of 'memo_list_bloc.dart';

class MemoListState {
  MemoListState({
    required this.memos,
    required this.convertedToTodo,
  });

  final List<String> memos;

  final bool convertedToTodo;
}
