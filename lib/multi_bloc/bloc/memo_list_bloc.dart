import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_samples/repository/calender_repository.dart';
import 'package:bloc_samples/repository/memo_repository.dart';

part 'memo_list_event.dart';
part 'memo_list_state.dart';

class MemoListBloc extends Bloc<MemoListEvent, MemoListState> {
  MemoListBloc({
    required this.memoRepository,
    required this.calenderRepository,
  }) : super(MemoListState(memos: [], convertedToTodo: false)) {
    on<MemoListEventAdded>(_onAdded);
    on<MemoListEventConvertedToTodo>(_onConvertedToTodo);
  }

  final MemoRepository memoRepository;

  final CalenderRepository calenderRepository;

  FutureOr<void> _onAdded(
    MemoListEventAdded event,
    Emitter<MemoListState> emit,
  ) {
    memoRepository.addMemo(event.memo);
    emit(MemoListState(memos: memoRepository.memos, convertedToTodo: false));
  }

  FutureOr<void> _onConvertedToTodo(
    MemoListEventConvertedToTodo event,
    Emitter<MemoListState> emit,
  ) {
    calenderRepository.addTodo(
      group: event.group,
      title: event.memo,
    );
    memoRepository.removeMemo(event.memo);
    emit(MemoListState(memos: memoRepository.memos, convertedToTodo: true));
  }
}
