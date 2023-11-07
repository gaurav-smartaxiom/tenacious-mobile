import 'package:flutter/material.dart';

class SmsSwitchListItem extends StatelessWidget {
  final String label;
  final bool switchValue;
  final Function(bool) onChanged;

  SmsSwitchListItem({
    required this.label,
    required this.switchValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text('Enable', style: TextStyle(fontSize: 15)),
      trailing: Switch(
        value: switchValue,
        onChanged: (newValue) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enable $label?"),
                content: Text("Do you want to enable $label?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      onChanged(newValue); // Call the provided onChanged function
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
