import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key, required this.todoCategories}) : super(key: key);

  final TodoCategoryCollection todoCategories;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: todoCategories.todoCategories.length,
        itemBuilder: (context, index) {
          var todoCategory = todoCategories.todoCategories[index];
          return TodoCategoryListItem(
            todoCategoryItem: todoCategory,
          );
        },
      ),
    );
  }
}

typedef RemoveTodoCallback = void Function(int index);
typedef CompleteTodoCallback = void Function(int index, bool isCompleted);

class TodoCategoryListItem extends StatelessWidget {
  const TodoCategoryListItem({
    Key? key,
    required this.todoCategoryItem,
  }) : super(key: key);

  final TodoCategory todoCategoryItem;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              todoCategoryItem.categoryName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: todoCategoryItem.todoCollection.todos.length,
            itemBuilder: (context, index) {
              var todo = todoCategoryItem.todoCollection.todos[index];
              return TodoListItem(
                index: index,
                todoCategoryName: todoCategoryItem.categoryName,
                todo: todo,
              );
            },
          ),
        ],
      ),
    );
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.index,
    required this.todo,
    required this.todoCategoryName,
  }) : super(key: key);

  final Todo todo;
  final int index;
  final String todoCategoryName;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var completeTodo = appState.handleCompleteTodo;
    var removeTodo = appState.handleRemoveTodo;

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
                onChanged: (isChecked) => {
                      completeTodo(
                          todo.id, todoCategoryName, isChecked ?? false),
                    }),
            SizedBox(width: 10.0),
            Expanded(child: Text(todo.name)),
            SizedBox(width: 10.0),
            IconButton(
                onPressed: () => {removeTodo(todo.id, todoCategoryName)},
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
