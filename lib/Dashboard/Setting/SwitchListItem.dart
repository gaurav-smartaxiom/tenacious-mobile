import 'package:flutter/material.dart';

class SmsSwitchListItem extends StatelessWidget {
  final bool switchValue;
  final Function(bool) onChanged;

  SmsSwitchListItem({
    required this.switchValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8,left: 8),
        height: 55,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text(
                "Enable Alerts",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: ListTile(
                // title: Text(label),
                //subtitle: Text('En', style: TextStyle(fontSize: 15)),
                trailing: Switch(
                  value: switchValue,
                  onChanged: (newValue) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Enable SMS?"),
                          content: Text("Do you want to enable SMS?"),
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
                                onChanged(
                                    newValue); // Call the provided onChanged function
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
