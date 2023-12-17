class MemoRepository {
  final _memos = <String>[];

  List<String> get memos => _memos.toList();

  void addMemo(String memo) {
    _memos.add(memo);
  }

  void removeMemo(String memo) {
    _memos.remove(memo);
  }
}
