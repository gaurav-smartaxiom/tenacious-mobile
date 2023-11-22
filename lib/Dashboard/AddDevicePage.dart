import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class AddDevicePage extends StatefulWidget {
  final String deviceUuid;
  AddDevicePage({required this.deviceUuid});

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  int percentage = 20;
   String selectedSensor = '';
  bool isActive = false;
  List<bool> sensorSwitches =

      List.generate(14, (index) => true);
      
      
       @override
  void initState() {
    super.initState();
     loadSessionData().then((token) {
    // Fetch shipments from the API when the widget is initialized
   fetchData(token);
  });
}
  
Future<String?> loadSessionData() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final email = sharedPreferences.getString('email');
  final password = sharedPreferences.getString('password');
  final token = sharedPreferences.getString('token');

  print('Stored Email: $email');
  print('Stored Password: $password');
  print("token-------------$token");
  return token; // Return the token as a Future<String?>
}

Future<void> fetchData(String ?token) async {
  final String backendUrl = 'http://192.168.29.11:4000/api/v1/sensors';
 print('Tokennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn: "$token"');
 final response = await http.get(
        Uri.parse(backendUrl),
         headers: {
              'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvZmZpY2lhbEVtYWlsIjoiZ2F1cmF2QHNtYXJ0YXhpb20uY29tIiwiaWQiOiI2Mzc0ZDU3YzAyYTMwNmZjNjUwMTM4MGUiLCJ0ZW5hbnROYW1lIjoiSG9uZXl3ZWxsSW50ZXJuYXRpb25hbChJbmRpYSlQdnRMdGQiLCJpYXQiOjE3MDA2NTg0NzUsImV4cCI6MTcwMDc0NDg3NX0.Ov2c1nq_4NsEg5q53zmjbkFnQv86fqay2dKzgj4o5U0', // Use the token directly
       // 'Authorization': 'Bearer $token',

         }
      );

      print('response, $response');
      print("Response Body: ${response.body}");
       print(response.statusCode == 200);
//     // Replace with your API endpoint
//     // if (response.statusCode == 200) {
//     //   final List<dynamic> data = json.decode(response.body);
//     //   // Update your sensorSwitches list with the data received from the API
//     //   setState(() {
//     //     // Assuming your API response is a list of booleans
//     //     sensorSwitches = List.generate(data.length, (index) => data[index]);
//     //   });
//     // } else {
//     //   throw Exception('Failed to load data');
//     // }
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Device Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              _buildProgressIndicator(),
            //Divider(),
              _buildDeviceInfoRow('State', _buildSwitch('Active', isActive)),
              Divider(),
              _buildDeviceInfoRow('Status', 'Connected'),
              Divider(),
              _buildDeviceInfoRow('Last Connected', '2 mins ago'),
              Divider(),
              _buildDeviceInfoRow('Model Name', 'Block tracker'),
              Divider(),
              _buildDeviceInfoRow('Manufacturer’s Name', 'SMARTAXIOM'),
              Divider(),
              _buildDeviceInfoRow('Software version', '0.01'),
              Divider(),
              _buildDeviceInfoRow('Boot Version', '00.01'),
              Divider(),
              _buildDeviceInfoRow('Firmware Version', '00.01'),
              Divider(),

              _buildSensorHeading(),
              SizedBox(height: 20), // Sensor heading row
              _buildManualSection(),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton("Reset Device", () {
                      print("Reset Device button pressed");
                      // Implement the logic for Reset Device button
                      // You can perform actions like calling the API or resetting the device here
                    }),
                  ),
                  SizedBox(width: 15.0), // Add spacing between buttons
                  Expanded(
                    child: _buildActionButton("Update Firmware", () {
                      print("Update Firmware button pressed");
                      // Implement the logic for Update Firmware button
                      // You can perform actions like calling the API or updating firmware here
                    }),
                  ),
                ],
              ), // Manual section with sensor tags and switches
            ],
          ),
        ),
      ),
    );
  }




void _handleSensorSelection(String sensorName) {
  int selectedSensorIndex = int.parse(sensorName.split(' ')[1]) - 1; // Extract the sensor index
  bool currentSwitchValue = sensorSwitches[selectedSensorIndex];
print(sensorName);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Sensor: $sensorName"),
        content: Row(
          children: [
            Text("Switch "),
            Switch(
              value: currentSwitchValue,
              onChanged: (value) {
                setState(() {
                  // Update the switch value based on user interaction
                  sensorSwitches[selectedSensorIndex] = value;
                  print( sensorSwitches[selectedSensorIndex] );
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              // Perform any additional actions if needed
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}








 Future<void> _showSwitchStateDialog(bool newValue) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(newValue ? "Enable isActive?" : "Disable isActive?"),
        content: Text(newValue
            ? "Do you want to enable the switch?"
            : "Do you want to disable the switch?"),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              setState(() {
                isActive = newValue;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _buildSwitch(String label, bool value) {
  return Row(
    children: [
      Text(label),
      Switch(
        value: value,
        onChanged: (value) {
          _showSwitchStateDialog(value);
        },
      ),
    ],
  );
}
Widget _buildSwitchSensor(String label, bool value) {
  return Row(
    children: [
      Text(label),
      Switch(
        value: value,
        onChanged: (value) {
         // _showSwitchStateDialog(value);
        },
      ),
    ],
  );
}
  Widget _buildProgressIndicator() {
    return Column(
      children: <Widget>[
        // Single Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _buildDeviceInfoRow1('Device UUID: ', widget.deviceUuid),
            Row(
              children: [
                _buildNetworkWidget(),
                if (percentage == 20) Center(child: Icon(MdiIcons.battery)),
                SizedBox(width: 8.0), // Adjust the width as needed
                Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceInfoRow1(String label, dynamic trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the start
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(width: 1), // Adjust the width according to your needs
                  Text(
                    ' $trailing',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkWidget() {
    // Replace the following line with your custom network widget logic
    return Center(child: Icon(Icons.network_cell));
  }

  Widget _buildDeviceInfoRow(String label, dynamic trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          trailing is Widget ? trailing : Text(trailing), // Check if trailing is a Widget or String
        ],
      ),
    );
  }

  
  Widget _buildSensorHeading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Sensor Tags',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildManualSection() {
    return SingleChildScrollView(
      child: Container(
        width: 500,
        height: 250,
        child: ListView.builder(
          itemCount: sensorSwitches.length + 1, // +1 for the Divider
          itemBuilder: (BuildContext context, int index) {
            if (index == sensorSwitches.length) {
              return Divider(); // Divider after the last sensor
            } else {
              return _buildManualItem('Sensor ${index + 1}', sensorSwitches[index]);
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 18.0)), // Customize the text style
    );
  }

  Widget _buildManualItem(String sensorTag, bool switchValue) {
    return GestureDetector(
      onTap: () {
        _handleSensorSelection(sensorTag);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(sensorTag),
            _buildSwitchSensor('', switchValue),
          ],
        ),
      ),
    );
  }

}
