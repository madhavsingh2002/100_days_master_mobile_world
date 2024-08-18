// lib/
// ├── main.dart
// ├── models/
// │   └── todo.dart
// ├── viewmodels/
// │   └── todo_viewmodel.dart
// ├── views/
// │   └── todo_list_screen.dart
// └── widgets/
//     └── todo_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mvvm_api/viewmodels/todo_viewmodel.dart';
import 'package:todo_mvvm_api/views/todo_list_screen.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoViewmodel())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}
