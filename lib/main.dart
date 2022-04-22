import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:new_calc/screens/1_calc/calc_screen.dart';
import 'package:new_calc/screens/3_todolist/todo_screen.dart';
import 'package:new_calc/screens/4_calendar/calendar_screen.dart';
import 'package:new_calc/screens/5_networking/networking_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.redAccent,
      systemNavigationBarColor: Color(0xffcfd9df),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.grey));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  List<String> _todoItems = [];

  @override
  Widget build(BuildContext context) {
    _getPrefs();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Приложение'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('1. Калькулятор'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CalcScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('3. Список ToDo'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ToDoListScreen(todoItems: _todoItems,),));
                },
              ),
              ElevatedButton(
                child: const Text('4. Календарь'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalendarScreen(title: 'Календарь',)),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('5. Взаимодействие с RestAPI'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NetworkingScreen()),
                  );
                },
              ),
            ]),
      ),
    );
  }

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('TodoList') != null) {
      _todoItems = prefs.getStringList('TodoList')!;
    }
  }
}

