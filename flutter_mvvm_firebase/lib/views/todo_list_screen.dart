import 'package:flutter/material.dart';
import 'package:flutter_mvvm_firebase/viewmodels/todo_viewmodel.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({super.key});
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final todoViewmodel = Provider.of<TodoViewModel>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todoViewmodel.fetchTodos();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
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
                )),
                IconButton(
                    onPressed: () {
                      if (_titleController.text.trim().isNotEmpty) {
                        todoViewmodel.addTodo(_titleController.text);
                        _titleController.clear();
                      }
                    },
                    icon: Icon(Icons.add))
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: todoViewmodel.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoViewmodel.todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                final _updateController =
                                    TextEditingController(text: todo.title);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('edit todo'),
                                          content: TextField(
                                              controller: _updateController,
                                              decoration: InputDecoration(
                                                  labelText: 'Edit Title')),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                todoViewmodel.updateTodo(
                                                    todo.id,
                                                    _updateController.text);
                                                _updateController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('update'),
                                            )
                                          ],
                                        ));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () =>
                                  todoViewmodel.deleteTodo(todo.id),
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
