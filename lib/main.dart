import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';

// Pages
import 'package:todo_app/pages/completed_page.dart';
import 'package:todo_app/pages/settings_page.dart';
import 'package:todo_app/pages/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const BaseLayout(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var todoCollection = TodoCollection();
  var selectedPageIndex = 0;

  void setSelectedPageIndex(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  void handleAddTodo(String name) {
    todoCollection.add(name);
    notifyListeners();
  }

  void handleRemoveTodo(int index) {
    todoCollection.remove(index);
    notifyListeners();
  }

  void handleCompleteTodo(int index, bool isCompleted) {
    todoCollection.setCompleted(index, isCompleted);
    notifyListeners();
  }
}

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var selectedPageIndex = appState.selectedPageIndex;

    final theme = Theme.of(context);

    Widget page;
    String title;

    switch (appState.selectedPageIndex) {
      case 0:
        page = TodoPage();
        title = 'Todos';
      case 1:
        page = CompletedPage();
        title = 'Completed';

      case 2:
        page = SettingsPage();
        title = 'Settings';

      default:
        throw UnimplementedError('No widget for $selectedPageIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 24.0,
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.primary,
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: selectedPageIndex,
                onDestinationSelected: (index) {
                  appState.setSelectedPageIndex(index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.list),
                    label: Text('Todo'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.check),
                    label: Text('Completed'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: page,
            ))
          ],
        ),
      );
    });
  }
}
