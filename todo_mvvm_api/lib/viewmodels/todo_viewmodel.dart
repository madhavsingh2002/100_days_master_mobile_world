import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_mvvm_api/models/todo.dart';
class TodoViewmodel extends ChangeNotifier{
  final List<Todo> _todos =  [];
  List<Todo> get todos => List.unmodifiable(_todos);
  final String baseUrl = 'http://192.168.1.103:3000/api/todos';
  Future<void> fetchTodos() async{
    try{
      final response = await http.get(Uri.parse('$baseUrl/todo'));
      if(response.statusCode==200){
        final List<dynamic> todoList  = jsonDecode(response.body);
        _todos.clear();
        todoList.forEach((item){
          _todos.add(Todo(id: item['_id'], title: item['title']));
        });
        notifyListeners();
      }
      else{
        throw Exception('Failed to load todos');
      }
    }
    catch(e){
      print('Error Fetching todo: $e');
    }
  }
  Future<void> addTodos(String title) async{
    try{
      final response = await http.post(Uri.parse('$baseUrl/todo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title':title}));
      if(response.statusCode == 201){
        final newTodo = Todo(id: json.decode(response.body)['id'],
        title: title);
        _todos.add(newTodo);
        notifyListeners();
      }
      else{
        throw Exception('Failed to add todo');
      }
    }
    catch(e){
      print('Error Adding todo: $e');
    }
  }
  Future<void> updateTodo(String id, String title) async{
    try{
      final response = await http.put(Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title':title}));
      if(response.statusCode == 200){
        final index =  _todos.indexWhere((todo)=> todo.id == id);
        if(index !=-1){
          _todos[index].title = title;
          notifyListeners();
        }
        
      }
      else{
        throw Exception('Failed to add todo');
      }
    }
    catch(e){
      print('Error Adding todo: $e');
    }
  }
  Future<void> deleteTodo(String id) async{
    try{
      final response = await http.delete(Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'});
      if(response.statusCode == 200){
        _todos.removeWhere((todo)=>todo.id == id);
        notifyListeners();
      }
      else{
        throw Exception('Failed to add todo');
      }
    }
    catch(e){
      print('Error Adding todo: $e');
    }
  }
}
// 84 - 18.
/// 