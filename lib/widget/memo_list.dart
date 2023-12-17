import 'package:flutter/material.dart';

class MemoList extends StatelessWidget {
  MemoList({
    super.key,
    this.memos = const [],
    this.onMemoSubmitted,
    this.onConvertedToTodo,
  });

  final List<String> memos;

  final ValueChanged<String>? onMemoSubmitted;

  final ValueChanged<({String title, String group})>? onConvertedToTodo;

  final _memoFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.shade100,
      margin: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 64.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: memos
                  .map((memo) => Row(
                        children: [
                          Expanded(child: Text(memo)),
                          const SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () => _onConvertToTodoButtonPressed(
                              context,
                              memo,
                            ),
                            icon: const Icon(Icons.checklist),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: _memoFieldKey,
              onFieldSubmitted: (text) {
                _memoFieldKey.currentState?.reset();
                onMemoSubmitted?.call(text);
              },
              decoration: const InputDecoration(labelText: 'memo'),
            ),
          ),
        ],
      ),
    );
  }

  void _onConvertToTodoButtonPressed(
    BuildContext context,
    String memo,
  ) async {
    final group = await showDialog<String>(
      context: context,
      builder: (context) {
        String? group;

        return AlertDialog(
          title: const Text('그룹 선택'),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  value: '가족',
                  title: const Text('가족'),
                  groupValue: group,
                  onChanged: (value) => setState(() => group = value),
                ),
                RadioListTile(
                  value: '개인',
                  title: const Text('개인'),
                  groupValue: group,
                  onChanged: (value) => setState(() => group = value),
                ),
                RadioListTile(
                  value: '업무',
                  title: const Text('업무'),
                  groupValue: group,
                  onChanged: (value) => setState(() => group = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.maybeOf(context)?.pop,
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.maybeOf(context)?.pop(group),
              child: const Text('결정'),
            ),
          ],
        );
      },
    );

    if (group == null) return;

    onConvertedToTodo?.call((title: memo, group: group));
  }
}
