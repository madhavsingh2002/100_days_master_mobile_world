import 'package:flutter/material.dart';
import 'package:todo_mvvm/models/todo.dart';
import 'package:uuid/uuid.dart';
class TodoViewmodel extends ChangeNotifier{
  final List<Todo> _todos =[]; // state.
  List<Todo> get todos => List.unmodifiable(_todos);
  void addTodo(String title){
    final newTodo = Todo(id: Uuid().v4(), title: title);
    _todos.add(newTodo);
    notifyListeners();
  }
  void updateTodo(String id, String newTitle){
    final index = _todos.indexWhere((item)=> item.id == id); /// -1 //
    if(index != -1){
      _todos[index].title = newTitle;
      notifyListeners();
    }
  }
  void deleteTodo(String id){
    final index = _todos.indexWhere((item)=> item.id == id); /// -1 //
    if(index != -1){
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
