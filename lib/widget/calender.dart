import 'package:bloc_samples/model/todo.dart';
import 'package:flutter/material.dart';

class Calender extends StatelessWidget {
  const Calender({super.key, this.todosPerDate = const []});

  final List<List<Todo>> todosPerDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8.0),
        itemCount: todosPerDate.length,
        itemBuilder: (context, index) {
          final todos = todosPerDate[index];
          final todo = todos.first;

          return Container(
            width: 100.0,
            color: Theme.of(context).highlightColor,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${todo.date.year}/${todo.date.month}/${todo.date.day}',
                ),
                const SizedBox(height: 8.0),
                ...todos.take(3).map((todo) => Text(
                      todo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _getColorByGroup(todo.group)),
                    )),
                if (todos.length > 3) Text('외 ${todos.skip(3).length} 건'),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
      ),
    );
  }

  Color? _getColorByGroup(String group) => switch (group) {
        '개인' => Colors.purple,
        '가족' => Colors.amber,
        '업무' => Colors.blue,
        _ => null,
      };
}
