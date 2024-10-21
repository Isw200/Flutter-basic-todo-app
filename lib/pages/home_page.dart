import 'package:counter/components/dialog_box.dart';
import 'package:counter/components/todo_tile.dart';
import 'package:counter/data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // hive box
  final _box = Hive.box('todos');
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    if (_box.get('todos') == null) {
      db.createInitialData();
    } else {
      db.loadTods();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  void addTask(String taskName) {
    if (taskName.isEmpty) {
      return;
    }

    setState(() {
      db.todos.add({
        'taskName': taskName,
        'isCompleted': false,
      });
      _controller.clear();
    });
  }

  void cheboxChange(bool? value, int index) {
    setState(() {
      db.todos[index]['isCompleted'] = value;
    });
    db.updateData();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) => DialogBox(
              controller: _controller,
              onSave: () {
                addTask(_controller.text);
                Navigator.pop(context);
                db.updateData();
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ));
  }

  void deleteTask(int index) {
    setState(() {
      db.todos.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todos.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.todos[index]['taskName'],
            isCompleted: db.todos[index]['isCompleted'],
            onCheckboxChanged: (bool? value) {
              cheboxChange(value, index);
            },
            deleteTodo: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
