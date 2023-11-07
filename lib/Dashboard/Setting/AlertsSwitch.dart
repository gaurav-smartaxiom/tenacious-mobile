import 'package:flutter/material.dart';

class AlertsSwitch extends StatefulWidget {
  final bool initialValue;

  AlertsSwitch({required this.initialValue});

  @override
  _AlertsSwitchState createState() => _AlertsSwitchState();
}
class _AlertsSwitchState extends State<AlertsSwitch> {
  late bool alertsEnabled;

  @override
  void initState() {
    super.initState();
    alertsEnabled = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Enable alerts"),
      tileColor: Colors.white,
      trailing: Switch(
        value: alertsEnabled,
        onChanged: (newValue) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(alertsEnabled ? "Disable alerts?" : "Enable alerts?"),
                content: Text(alertsEnabled ? "Do you want to disable alerts?" : "Do you want to enable alerts?"),
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
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        alertsEnabled = !alertsEnabled; // Toggle alerts on/off
                      });
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
