import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mdi/mdi.dart';

class AddDevicePage extends StatefulWidget {
  final String deviceUuid;
  AddDevicePage({required this.deviceUuid});

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

enum BatteryLevel {
  low,
  mediumLow,
  medium,
  mediumHigh,
  high,
}

BatteryLevel getBatteryLevel(int percentage) {
  if (percentage <= 20) {
    return BatteryLevel.low;
  } else if (percentage <= 50) {
    return BatteryLevel.mediumLow;
  } else if (percentage <= 75) {
    return BatteryLevel.medium;
  } else if (percentage <= 95) {
    return BatteryLevel.mediumHigh;
  } else {
    return BatteryLevel.high;
  }
}

Icon getBatteryIcon(int percentage) {
  Color iconColor;

  switch (getBatteryLevel(percentage)) {
    case BatteryLevel.low:
      iconColor = Colors.red;
      return Icon(MdiIcons.batteryAlert, color: iconColor);
    case BatteryLevel.mediumLow:
      iconColor = Colors.green;
      return Icon(MdiIcons.battery20, color: iconColor);
    case BatteryLevel.medium:
      iconColor = Colors.yellow;
      return Icon(MdiIcons.battery50, color: iconColor);
    case BatteryLevel.mediumHigh:
      iconColor = Colors.yellow;
      return Icon(MdiIcons.battery80, color: iconColor);
    case BatteryLevel.high:
      iconColor = Colors.blue;
      return Icon(MdiIcons.battery, color: iconColor);
  }
}

class _AddDevicePageState extends State<AddDevicePage> {
  int percentage = 20;
   String selectedSensor = '';
  bool isActive = false;
  bool isSensor=false;
  List<String> sensorNames = [];
  List<bool> sensorStates = [];    
       @override
  void initState() {
    super.initState();
     loadSessionData().then((token) {
    // Fetch shipments from the API when the widget is initialized
   fetchData(token);
  });
}
 void updatePercentage(int newPercentage) {
    setState(() {
      percentage = newPercentage;
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
              'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvZmZpY2lhbEVtYWlsIjoiZ2F1cmF2QHNtYXJ0YXhpb20uY29tIiwiaWQiOiI2Mzc0ZDU3YzAyYTMwNmZjNjUwMTM4MGUiLCJ0ZW5hbnROYW1lIjoiSG9uZXl3ZWxsSW50ZXJuYXRpb25hbChJbmRpYSlQdnRMdGQiLCJpYXQiOjE3MDA3MTc4MzEsImV4cCI6MTcwMDgwNDIzMX0.7hrIZ52s3zP0gzRGen4dFKrPA16pki8HR4bpXWWQO_c', // Use the token directly
       // 'Authorization': 'Bearer $token',

         }
      );

      print('response, $response');
      print("Response Body: ${response.body}");
       print(response.statusCode == 200);
   
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
     
      List<String> names = data.map((sensor) => sensor['sensorName']).cast<String>().toList();

  
    setState(() {
      //sensorSwitches = List.generate(data.length, (index) => data[index]['assign']);
      sensorNames = names;
       sensorStates = List.generate(sensorNames.length, (index) => false);
    });

    
    } else {
      throw Exception('Failed to load data');
    }
   }

void ResetDeviceInfo(int index, String sensorName, bool switchValue, bool isActive) {
  print('Index: $index, Sensor Name: $sensorName, Switch Value: $switchValue, isActive: $isActive');
}


void UpdateFirmwareInfo(int index, String sensorName, bool switchValue, bool isActive) {
  print('Index: $index, Sensor Name: $sensorName, Switch Value: $switchValue, isActive: $isActive');
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
      child: _buildActionButton("Reset Device", (int index, String sensorName, bool switchValue,bool isActive) {
        // Your logic for the "Reset Device" button

      }),
    ),
    SizedBox(width: 15.0), // Add spacing between buttons
    Expanded(
      child: _buildActionButton("Update Firmware", (int index, String sensorName, bool switchValue ,bool isActive) {
        // Your logic for the "Update Firmware" button
        //printUpdateFirmwareInfo(index, sensorName, switchValue);
      }),
    ),
  ],
)
// Manual section with sensor tags and switches
            ],
          ),
        ),
      ),
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
Future<void> _showSwitchSensorConfirmationDialog(String label, bool newValue, Function(bool) onChanged) async {
  print(newValue);
  print("qqqqqqqqqqqqqqqqqqqqqq");
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(newValue ? "Enable $label?" : "Disable $label?"),
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
              onChanged(newValue);
              print(onChanged);
              print("rrrrrrrrrrrrrrrrrrr");
              Navigator.of(context).pop();
              print("on chanagerdddd,$onChanged");
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
Widget _buildSwitchSensor(String label, bool value, Function(bool) onChanged) {
  print(label);
  print(onChanged);
  print(value);
  print("eeeeeeeeeeeeeeeeeeeeeeeeee");
  return Row(
    children: [
      Text(label),
      Switch(
        value: value,
        onChanged: (newValue) {
          _showSwitchSensorConfirmationDialog(label, newValue, onChanged);
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
        children: [
          // Assuming _buildDeviceInfoRow1 is a function you've defined elsewhere
          _buildDeviceInfoRow1('Device UUID: ', widget.deviceUuid),
          Row(
            children: [
              _buildNetworkWidget(),
              getBatteryIcon(percentage),
              SizedBox(width: 5.0),
              Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
  return Container(
    width: 500,
    height: 250,
    child: ListView.builder(
      itemCount: sensorNames.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildManualItem(index, sensorNames[index], sensorStates[index]);
      },
    ),
  );
}
Widget _buildActionButton(String label, void Function(int, String, bool, bool) onPressed) {
  return ElevatedButton(
    onPressed: () {
      // Get the index of the sensor you want to reset (you can replace 0 with the desired index)
      int indexToReset = 0;
      // Call your logic here
      onPressed(indexToReset, sensorNames[indexToReset], sensorStates[indexToReset], isActive);
      // Print index, sensor name, switch value, and isActive
      ResetDeviceInfo(indexToReset, sensorNames[indexToReset], sensorStates[indexToReset], isActive);
      onPressed(indexToReset, sensorNames[indexToReset], sensorStates[indexToReset], isActive);
      UpdateFirmwareInfo(indexToReset, sensorNames[indexToReset], sensorStates[indexToReset], isActive);
    },
    child: Text(label, style: TextStyle(fontSize: 18.0)),
  );
}




Widget _buildManualItem(int index, String sensorTag, bool isSensorActive) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
           //  handleSensorClick(index, sensorTag, isSensorActive);
            },
            child: Text(
              sensorTag,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        _buildSwitchSensor('', isSensorActive, (newValue) {
          // Update the switch state in the list when it changes
          setState(() {
            sensorStates[index] = newValue;
          });
        //  handleSensorClick(index, sensorTag, newValue);
        }),
        // You can add additional widgets here if needed
      ],
    ),
  );
}

}