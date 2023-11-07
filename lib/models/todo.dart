class Todo {
  late String _name;
  late int _id;
  late bool _isCompleted;
  late DateTime? _dateCompleted;

  Todo({required String name, required int id, bool isCompleted = false}) {
    _name = name;
    _id = id;
    _isCompleted = false;
  }

  String get name => _name;
  int get id => _id;
  bool get isCompleted => _isCompleted;
  DateTime? get dateCompleted => _dateCompleted;
}

class TodoCollection {
  List<Todo> _todos = <Todo>[];

  List<Todo> get todos => _todos;

  void add(String name) {
    late int id;
    if (todos.isEmpty) {
      id = 0;
    } else {
      id = todos.last.id + 1;
    }

    var todo = Todo(
      id: id,
      name: name,
    );

    _todos.add(todo);
  }

  void remove(int id) {
    _todos.removeWhere((element) => element.id == id);
  }

  void setCompleted(int id, bool isCompleted) {
    var index = _todos.indexWhere((element) => element.id == id);
    _todos[index]._isCompleted = isCompleted;
    if (isCompleted) {
      _todos[index]._dateCompleted = DateTime.now();
    } else {
      _todos[index]._dateCompleted = null;
    }
  }
}

class TodoCategory {
  late String _categoryName;
  late TodoCollection _todoCollection;

  TodoCategory({required String categoryName}) {
    _categoryName = categoryName;
    _todoCollection = TodoCollection();
  }

  String get categoryName => _categoryName;
  TodoCollection get todoCollection => _todoCollection;

  void addTodoToCategory(String name) {
    todoCollection.add(name);
  }

  void removeTodoFromCategory(int index) {
    todoCollection.remove(index);
  }
}

class TodoCategoryCollection {
  late List<TodoCategory> _todoCategories;

  TodoCategoryCollection() {
    _todoCategories = <TodoCategory>[];
  }
  List<TodoCategory> get todoCategories => _todoCategories;

  void addCategory(TodoCategory category) {
    _todoCategories.add(category);
  }

  void removeCategory(int index) {
    _todoCategories.removeAt(index);
  }
}
