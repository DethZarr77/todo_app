import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo.dart';
import 'package:intl/intl.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var todoItems = appState.todoCollection;
    var filteredTodos =
        todoItems.todos.where((todo) => todo.isCompleted).toList();

    var box = Hive.box(settingsBox);
    var darkMode = box.get('darkMode', defaultValue: false);
    var svgColor = darkMode ? Colors.white : Colors.black;
    const String assetName = 'images/sad-face-emoji.svg';

    if (filteredTodos.isEmpty) {
      return Center(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('No completed tasks... (yet)'),
            SizedBox(width: 10),
            SvgPicture.asset(
              assetName,
              semanticsLabel: 'Sad Face',
              height: 40,
              width: 40,
              colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
            )
          ]));
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: filteredTodos.length,
          itemBuilder: (context, index) {
            var todo = filteredTodos[index];
            return CompletedListItem(todo: todo);
          },
        ),
      ],
    );
  }
}

class CompletedListItem extends StatelessWidget {
  const CompletedListItem({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    var completedDateString =
        DateFormat('EEEE, d MMMM - HH:mm a').format(todo.dateCompleted!);
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.green),
          SizedBox(width: 10.0),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.name,
              ),
              SizedBox(height: 5.0),
              Text('@ $completedDateString',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12.0))
            ],
          )),
        ],
      ),
    );
  }
}
