import 'package:flutter/material.dart';
import 'package:todo_app/utils/validators/text_validator.dart';

typedef AddTodoCallback = void Function(String name);

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Call onSaved on every FormField
      _formKey.currentState!.save();

      // Run submit callback
      widget.onSubmit(_taskName);

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
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(18),
              ),
              child: const Text('Add'),
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
          // error: ,
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
