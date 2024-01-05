import 'package:flutter/material.dart';

class DailyReportSwitch extends StatefulWidget {
  final bool initialValue;

  DailyReportSwitch({required this.initialValue});

  @override
  _DailyReportSwitchState createState() => _DailyReportSwitchState();
}

class _DailyReportSwitchState extends State<DailyReportSwitch> {
  late bool dailyReportEnabled;

  @override
  void initState() {
    super.initState();
    dailyReportEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8,left: 8),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8)),
      child: ListTile(
      title: Text("Enable Daily Report"),
      //tileColor: Colors.grey,
      trailing: Switch(
        value: dailyReportEnabled,
        onChanged: (newValue) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(dailyReportEnabled ? "Disable Daily Report?" : "Enable Daily Report?"),
                content: Text(dailyReportEnabled
                    ? "Do you want to disable the daily report?"
                    : "Do you want to enable the daily report?"),
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
                      setState(() {
                        dailyReportEnabled = !dailyReportEnabled; // Toggle daily report enablement
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      )
    );
  }
}
