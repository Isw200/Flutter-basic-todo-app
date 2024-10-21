import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todos = [];

  // box
  final _box = Hive.box('todos');

  void createInitialData() {
    todos = [
      {'taskName': 'Task 1', 'isCompleted': false},
      {'taskName': 'Task 2', 'isCompleted': false},
    ];
  }

  void loadTods() {
    todos = _box.get('todos');
  }

  void updateData() {
    _box.put('todos', todos);
  }
}
