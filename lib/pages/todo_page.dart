import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:todo_app/main.dart";
import "package:todo_app/widgets/todo_form.dart";
import "package:todo_app/widgets/todo_list.dart";

class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var todoItems = appState.todoCollection.todos;
    var handleAddTodo = appState.handleAddTodo;

    return Column(
      children: [
        TodoForm(onSubmit: handleAddTodo),
        SizedBox(height: 16),
        TodoList(todoCollection: todoItems),
      ],
    );
  }
}
