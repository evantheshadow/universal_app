import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ToDoListScreen extends StatefulWidget {
  List<String> todoItems;

  ToDoListScreen({Key? key, required this.todoItems}) : super(
      key: key
  );

  @override
  createState() => ToDoListScreenState();
}

class ToDoListScreenState extends State<ToDoListScreen> {
  // String _haveStarted3Times = '';
  // List<String> _todoItems = _getPrefs() as List<String>;
  // if (prefs.getStringList('TodoList') != null) {
  //   _todoItems = prefs.getStringList('TodoList')!;
  // }
  // List<String> todoItems = [];

  @override
  Widget build(BuildContext context) {
    _getPrefs();
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _addTodoItem,
          tooltip: 'Хотите добавить задачу?',
          child: const Icon(Icons.add)),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          print("To Do Items Length: ${widget.todoItems.length}");
          if (index < widget.todoItems.length) {
            return _buildTodoItem(widget.todoItems[index], index);
          } else {
            return const Text('');
          }
        }
        );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
        title: Text(todoText),
        trailing: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 7,
        padding: const EdgeInsets.all(0),
        color: const Color(0xffffb199).withOpacity(0.6),
        splashColor: Colors.purple,
        onPressed: () {
          _removeTodoItem(index);
        },
        child: const Icon(Icons.clear_rounded),
      ),
    );
  }

  void _addTodoItem() {
    // Push this page onto the stack
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text('Добавление задачи')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: const InputDecoration(
                hintText: 'Введите вашу задачу',
                contentPadding: EdgeInsets.all(16.0)),
          ));
    }));
  }

  void _addItem(String task) {
    if (task.isNotEmpty) {
      setState(() => widget.todoItems.add(task));
      _setPrefs();
    }
  }

  void _removeTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Задача "${widget.todoItems[index]}" выполнена?'),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Отмена'),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: const Text('Так точно, капитан!'),
                    onPressed: () {
                      _removeItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _removeItem(int index) {
    setState(() => widget.todoItems.removeAt(index));
    _setPrefs();
  }

  void _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('TodoList', widget.todoItems);
  }

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('TodoList') != null) {
      widget.todoItems = prefs.getStringList('TodoList')!;
    }
  }
}