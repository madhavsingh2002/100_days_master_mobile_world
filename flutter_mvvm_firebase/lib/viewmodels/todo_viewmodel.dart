import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_firebase/models/todo.dart';
import 'package:uuid/uuid.dart';
class TodoViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  TodoViewModel() {
    fetchTodos();
  }

  // Fetch all todos from Firestore
  Future<void> fetchTodos() async {
    try {
      final QuerySnapshot snapshot = await _todosCollection.get();
      _todos.clear();
      snapshot.docs.forEach((doc) {
        _todos.add(Todo(
          id: doc.id,
          title: doc['title'],
        ));
      });
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  // Add a new todo to Firestore
  Future<void> addTodo(String title) async {
    try {
      final newTodo = Todo(
        id: Uuid().v4(),
        title: title,
      );
      await _todosCollection.doc(newTodo.id).set({
        'title': newTodo.title,
      });
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  // Update an existing todo in Firestore
  Future<void> updateTodo(String id, String newTitle) async {
    try {
      await _todosCollection.doc(id).update({
        'title': newTitle,
      });
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        _todos[index].title = newTitle;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  // Delete a todo from Firestore
  Future<void> deleteTodo(String id) async {
    try {
      await _todosCollection.doc(id).delete();
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
// 84 - 18.
/// 