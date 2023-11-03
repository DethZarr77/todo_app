import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box(settingsBox);
    var darkMode = box.get('darkMode', defaultValue: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Dark Mode'),
            Switch(
                value: darkMode,
                onChanged: (val) {
                  box.put('darkMode', !darkMode);
                }),
          ],
        ),
      ],
    );
  }
}
