import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_mvvm_api/models/todo.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class TodoViewmodel extends ChangeNotifier {
  final List<Todo> _todos = []; // state.
  List<Todo> get todos => List.unmodifiable(_todos);
  final String baseUrl = 'http://192.168.1.104:3000/api/blogs';
  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/blog'));
      if (response.statusCode == 200) {
        final List<dynamic> todoList = jsonDecode(response.body);
        _todos.clear();
        todoList.forEach((todoData) {
          _todos.add(Todo(id: todoData['_id'], title: todoData['title']));
        });
        notifyListeners();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todo: $e');
    }
  }

  Future<void> addTodos(String title) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/blog'), 
      headers: {'Content-Type':'application/json'},
      body: json.encode({'title': title}));
      if(response.statusCode == 201){
        final newTodo = Todo(id: json.decode(response.body)['id'],
        title: title);
        _todos.add(newTodo);
        notifyListeners();
      }
      else{
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      print('Error fetching todo: $e');
    }
  }
  Future<void> updateTodo(String id, String newTitle) async{
    try{
      final response = await http.put(Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': newTitle})
      );
      if(response.statusCode== 200){
        final index = _todos.indexWhere((todo)=> todo.id ==id);
        if(index !=-1){
          _todos[index].title = newTitle;
          notifyListeners();
        }
      }
      else{
        throw Exception('Failed to update todo');
      }
    }
    catch(e){
      print('Error updating todo: $e');
    }
  }
  Future<void> deleteTodo(String id) async{
    try{
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if(response.statusCode == 200){
        _todos.removeWhere((todo)=> todo.id == id);
        notifyListeners();
      }
      else{
        throw Exception('Failed to delete todo');
      }
    }
    catch(e){
      print('Error deleting todo: $e');
    }
  }
}
