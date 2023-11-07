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
    var todoCategories = appState.todoCategoryCollection;
    var handleAddTodo = appState.handleAddTodo;
    var handleAddFour = appState.handleAddFourTodos;

    return Expanded(
      child: Column(
        children: [
          TodoForm(onSubmit: handleAddTodo),
          SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                handleAddFour('Custom Category');
              },
              child: Text('Add four todos')),
          TodoList(todoCategories: todoCategories),
        ],
      ),
    );
  }
}
