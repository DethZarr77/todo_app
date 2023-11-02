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

  void remove(int index) {
    _todos.removeAt(index);
  }

  void setCompleted(int index, bool isCompleted) {
    _todos[index]._isCompleted = isCompleted;
    if (isCompleted) {
      _todos[index]._dateCompleted = DateTime.now();
    } else {
      _todos[index]._dateCompleted = null;
    }
  }
}
