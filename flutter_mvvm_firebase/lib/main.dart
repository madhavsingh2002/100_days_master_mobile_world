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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_firebase/viewmodels/todo_viewmodel.dart';
import 'package:flutter_mvvm_firebase/views/todo_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoViewModel())],
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
