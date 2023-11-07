import 'package:flutter/material.dart';
import 'package:todo_app/utils/validators/text_validator.dart';

typedef AddTodoCallback = void Function(String name, String category);

class TodoForm extends StatefulWidget {
  // const TodoForm({super.key});
  TodoForm({Key? key, required this.onSubmit}) : super(key: key);

  final AddTodoCallback onSubmit;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

final _formKey = GlobalKey<FormState>();

class _TodoFormState extends State<TodoForm> {
  String _taskName = '';

  List<String> items = ['Work', 'Personal', 'Shopping'];
  String selectedCategory = 'Work';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Call onSaved on every FormField
      _formKey.currentState!.save();

      // Run submit callback
      widget.onSubmit(_taskName, selectedCategory);

      // Reset form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FormTextInput(
                labelText: 'Task name',
                handleChange: (value) => setState(() {
                  _taskName = value;
                }),
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedCategory,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              underline: Container(
                height: 2,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ));
  }
}

typedef HandleChangeCallback = void Function(String value);

class FormTextInput extends StatelessWidget {
  const FormTextInput({
    Key? key,
    required this.labelText,
    required this.handleChange,
  }) : super(key: key);

  // Label text for the input
  final String labelText;
  // Callback function to handle input onChange
  final HandleChangeCallback handleChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      validator: (value) => textValidator(value),
      onSaved: (newValue) => handleChange(newValue ?? ''),
    );
  }
}
