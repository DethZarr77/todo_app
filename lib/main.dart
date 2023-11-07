import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'package:todo_app/models/todo.dart';

// Pages
import 'package:todo_app/pages/completed_page.dart';
import 'package:todo_app/pages/settings_page.dart';
import 'package:todo_app/pages/todo_page.dart';

const settingsBox = 'settings';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(settingsBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(settingsBox).listenable(),
      builder: (context, box, widget) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return ChangeNotifierProvider(
          create: (context) => MyAppState(),
          child: MaterialApp(
            title: 'Todo App',
            debugShowCheckedModeBanner: false,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.red,
                  background: Colors.white,
                  brightness: Brightness.light),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.black,
                ),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.red,
                  background: Colors.black,
                  brightness: Brightness.dark),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.white,
                ),
              ),
              useMaterial3: true,
            ),
            home: const BaseLayout(),
          ),
        );
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  var todoCategoryCollection = TodoCategoryCollection();

  var selectedPageIndex = 0;

  void setSelectedPageIndex(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  void handleAddTodo(String name, String category) {
    print('handleAddTodo called - $name $category');
    // print(category);

    var foundCategory = todoCategoryCollection.todoCategories
        .firstWhereOrNull((element) => element.categoryName == category);

    if (foundCategory != null) {
      foundCategory.addTodoToCategory(name);
    } else {
      var todoCategory = TodoCategory(categoryName: category);
      todoCategory.addTodoToCategory(name);
      todoCategoryCollection.addCategory(todoCategory);
    }

    notifyListeners();
  }

  void handleAddFourTodos(String categoryName) {
    handleAddTodo(
      'Buy milk',
      categoryName,
    );
    handleAddTodo(
      'Buy eggs',
      categoryName,
    );
    handleAddTodo(
      'Buy bread',
      categoryName,
    );
    handleAddTodo(
      'Buy butter',
      categoryName,
    );
  }

  void handleRemoveTodo(int id, String categoryName) {
    var foundCategory = todoCategoryCollection.todoCategories
        .firstWhereOrNull((category) => category.categoryName == categoryName);
    if (foundCategory != null) {
      foundCategory.todoCollection.remove(id);
    }
    notifyListeners();
  }

  void handleCompleteTodo(int id, String categoryName, bool isCompleted) {
    var foundCategory = todoCategoryCollection.todoCategories
        .firstWhereOrNull((category) => category.categoryName == categoryName);
    if (foundCategory != null) {
      foundCategory.todoCollection.setCompleted(id, isCompleted);
    }
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
              // color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
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
                    label: Text('Todos'),
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
              padding: EdgeInsets.all(15),
              child: page,
            ))
          ],
        ),
      );
    });
  }
}
