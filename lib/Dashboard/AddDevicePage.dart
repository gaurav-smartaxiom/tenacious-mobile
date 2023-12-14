import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/Dashboard/Dashboard.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mdi/mdi.dart';
import 'package:mobileapp/Dashboard/Setting/ResetDevice.dart';
import 'package:mobileapp/Dashboard/Setting/shipmentss.dart';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'package:mobileapp/Dashboard/WindowPage.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/userprofile.dart';
import 'package:mobileapp/Dashboard/AddDevicePage.dart';

class AddDevicePage extends StatefulWidget {
 final Map<String, dynamic> decodedToken;
  //AddDevicePage({required this.decodedToken})
  final String deviceUuid;
  AddDevicePage({required this.deviceUuid,required this.decodedToken});

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
   int _selectedIndex = 0;
  bool isActive = false;
  bool isSensor=false;
  List<String> sensorNames = [];
  List<bool> sensorStates = [];    
       @override
  void initState() {
    super.initState();
     loadSessionData().then((token) {
    // Fetch shipments from the API when the widget is initialized
   fetchSensorData(token);
  });
}

  

void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardPage(decodedToken: widget.decodedToken,)));
      } else if (index == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ShipmentPage(decodedToken: widget.decodedToken)));
      } else if (index == 4) {
        // Navigate to UserProfilePage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 3) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage(decodedToken: widget.decodedToken,)));
      }
      else if(index==2)
      
      {
Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => AddDevicePage(deviceUuid: '9876543210',decodedToken: widget.decodedToken,),
));
      }
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
  return token; 
}

Future<void> fetchSensorData(String ?token) async {
  
  //final String backendUrl = 'http://192.168.29.11:4000/api/v1/sensors';
  
  final String backendUrl=Sensor;
  
  final response = await http.get(
        Uri.parse(backendUrl),
         headers: {
           'Authorization': 'Bearer $token',
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
 void updatePercentage(int newPercentage) {
    setState(() {
      percentage = newPercentage;
    });
  }
void ResetDeviceInfo(int index, String sensorName, bool isSensorActive, bool isActive) {
  print("Sensor clicked: $sensorName, SensorState: $isSensorActive, State: $isActive");

  print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResetDevice(
        indexToReset: index,
        sensorName: sensorName,
        sensorState: isSensorActive,
        isActive1: isActive,
      ),
    ),
  );
}

void UpdateFirmwareInfo(int index, String sensorName, bool isSensorActive, bool isActive) {
  print('Update Firmware clicked. Sensor Name: $sensorName, Switch Value: $isSensorActive, IsActive: $isActive');

  // Add your logic for updating firmware here
  // You can use the parameters (index, sensorName, switchValue, isActive) to perform the necessary actions

  // For example, uncomment and modify the following code when you want to navigate to the UpdateFirmware screen
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => ShipmentDetailsPage(
  //      indexToReset: index,
  //       sensorName: sensorName,
  //       sensorState: isSensorActive,
  //       isActive1: isActive,
  //     ),
  //   ),
  // );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Device Information'),
        backgroundColor: Colors.blue,
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
  child: _buildActionButton("Reset Device ", (int index, String sensorName, bool isSensorActive, bool isActive)
  
   {
    print("Index: $index, SensorName: $sensorName, IsSensorActive: $isSensorActive, IsActive: $isActive");
 ResetDeviceInfo(index,sensorName,isSensorActive,isActive);
    print(sensorName);
  }),
),

    SizedBox(width: 11.0), 
    Expanded(
      child: _buildActionButton("UpdateFrimware",  (int index, String sensorName, bool switchValue ,bool isActive) {
        // Your logic for the "Update Firmware" button
        //printUpdateFirmwareInfo(index, sensorName, switchValue);
      }),
    ),
  ],
)

            ],
          ),
        ),
      ),

   bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed, // Fixed type bottom navigation bar
  showSelectedLabels: false, // Selected label ko hide karein
  showUnselectedLabels: false, // Unselected labels ko hide karein
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.window),
      label: 'Window',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_shipping),
      label: 'Shipment',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.devices_other),
      label: 'Add_Devices',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'User Profile',
    ),
  ],

 currentIndex: _selectedIndex,
  selectedItemColor: Colors.blue,
  onTap: _onItemTapped,
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
Widget _buildActionButton(String label, void Function(int, String, bool, bool) onPressed) {
  return ElevatedButton(
    onPressed: () {
      int index = sensorNames.indexOf(selectedSensor);
      String sensorName = selectedSensor;
      bool isSensorActive = sensorStates[index];
      onPressed(index, sensorName, isSensorActive, isActive);
      if (label == "Reset Device") {
        ResetDeviceInfo(index, sensorName, isSensorActive, isActive);
      } else if (label == "Update Firmware") {
        UpdateFirmwareInfo(index, sensorName, isSensorActive, isActive);
      }
    },
    child: Text(label, style: TextStyle(fontSize: 15.0)),
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
      
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        
          _buildDeviceInfoRow1('Device UUID: ', widget.deviceUuid),
          Row(
            children: [
              _buildNetworkWidget(),
              SizedBox(width: 5.0),
              Transform.rotate(
                angle: -9.4 / 2, 
                child: getBatteryIcon(percentage),
              ),
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
        mainAxisAlignment: MainAxisAlignment.start, 
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
                  SizedBox(width: 1), 
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
    return Center(child: Icon(Icons.network_cell));
  }

  Widget _buildDeviceInfoRow(String label, dynamic trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          trailing is Widget ? trailing : Text(trailing), 
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
        print("connnnnnnnnnnnnnnnnnnnn,$context");
        print(sensorNames[index]);
        print(sensorStates[index]);
        print(sensorNames[index]);
        return _buildManualItem(index, sensorNames[index], sensorStates[index], sensorNames[index]);
      },
    ),
  );
}


Widget _buildManualItem1(int index, String sensorName, bool sensorState) {
  return ListTile(
    title: Text(sensorName),
    subtitle: Text('State: $sensorState'),
    onTap: () {
      // Handle the click event for the sensor
   //   _onSensorClick(index, sensorName, sensorState);
      
    },
  );
}


Widget _buildManualItem(int index, String sensorTag, bool isSensorActive, String sensorName) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedSensor = sensorName; 
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              sensorTag,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildSwitchSensor('', isSensorActive, (newValue) {
            setState(() {
              sensorStates[index] = newValue;
            });
          }),
        ],
      ),
    ),
  );
}


// void _onSensorClick(int index, String sensorName, bool sensorState,    bool isActive) {
//   print("Sensor clicked: $sensorName, SensorState: $sensorState,  State:$isActive");




//   // Navigate to ResetDevice screen
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ResetDevice(
//         indexToReset: index,
//         sensorName: sensorName,
//         // Pass additional parameters if needed
//       ),
//     ),
//   );
// }


}