import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/todo_viewmodel.dart';

class TodoListScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final todoViewModel = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Todo Title'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if(_titleController.text.trim().isNotEmpty){
                    todoViewModel.addTodo(_titleController.text);
                    _titleController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoViewModel.todos.length,
              itemBuilder: (context, index) {
                final todo = todoViewModel.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          final _updateController = TextEditingController(text: todo.title);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Todo'),
                              content: TextField(
                                controller: _updateController,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    todoViewModel.updateTodo(
                                      todo.id,
                                      _updateController.text,
                                    );
                                    _updateController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Update'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => todoViewModel.deleteTodo(todo.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
