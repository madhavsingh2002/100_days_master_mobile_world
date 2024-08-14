import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/todo_viewmodel.dart';
import 'views/todo_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo MVVM',
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}
