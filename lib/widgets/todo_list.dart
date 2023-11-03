import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key, required this.todoCollection}) : super(key: key);

  final List<Todo> todoCollection;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: todoCollection.length,
      itemBuilder: (context, index) {
        var todo = todoCollection[index];
        return TodoListItem(
            index: index,
            todo: todo,
            removeTodo: appState.handleRemoveTodo,
            completeTodo: appState.handleCompleteTodo);
      },
    );
  }
}

typedef RemoveTodoCallback = void Function(int index);
typedef CompleteTodoCallback = void Function(int index, bool isCompleted);

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.index,
    required this.todo,
    required this.removeTodo,
    required this.completeTodo,
  }) : super(key: key);

  final Todo todo;
  final RemoveTodoCallback removeTodo;
  final CompleteTodoCallback completeTodo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: todo.isCompleted ? 0.3 : 1.0,
        child: Row(
          children: [
            Checkbox(
                value: todo.isCompleted,
                onChanged: (isChecked) =>
                    completeTodo(index, isChecked ?? false)),
            SizedBox(width: 10.0),
            Expanded(child: Text(todo.name)),
            SizedBox(width: 10.0),
            IconButton(
                onPressed: () => removeTodo(index),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  semanticLabel: 'Delete this todo',
                )),
          ],
        ),
      ),
    );
  }
}
