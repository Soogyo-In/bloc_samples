import 'package:bloc_samples/model/todo.dart';

class CalenderRepository {
  final _todos = <Todo>[
    Todo(
      date: DateTime(2023, 12, 12),
      title: '공부',
      group: '개인',
    ),
    Todo(
      date: DateTime(2023, 12, 12),
      title: '친구 약속',
      group: '개인',
    ),
    Todo(
      date: DateTime(2023, 12, 13),
      title: '쇼핑',
      group: '가족',
    ),
    Todo(
      date: DateTime(2023, 12, 14),
      title: '업무',
      group: '미팅',
    ),
  ];

  List<Todo> get todos => _todos;

  void addTodo({
    required String group,
    required String title,
  }) {
    _todos.add(Todo(
      date: DateTime(2023, 12, 12),
      title: title,
      group: group,
    ));
  }
}
