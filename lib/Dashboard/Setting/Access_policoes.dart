import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:shake/shake.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccessPolicies(),
    );
  }
}
class AccessPolicies extends StatefulWidget {
  @override
  AccessPoliciesState createState() => AccessPoliciesState();
}

class AccessPoliciesState extends State<AccessPolicies> {
  late ShakeDetector _shakeDetector;
  bool isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();

    _shakeDetector = ShakeDetector.autoStart(onPhoneShake: () {
      // Handle shake event
      _openBottomSheet();
    });
  }

  void _openBottomSheet() {
    setState(() {
      isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle settings option
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  // Handle profile option
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                 
                  Navigator.pop(context); 
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        final style = TextStyle(fontSize: 16, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal);
        return Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            cell,
            style: style,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Access Policies Page"),
        centerTitle: true,
        backgroundColor: Colors.blue,
         automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 120, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                  ),
                  children: [
                    buildRow(['Name', 'Action'], isHeader: true),
                    buildRow(['Super Admin', '']),
                    buildRow(['Admin', '']),
                    buildRow(['User', '']),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add logic for Remove button
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text('- Remove Selected', style: TextStyle(fontSize: 12, color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _openBottomSheet(); // Call _openBottomSheet on button click
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: Text('+ Add New Access Level', style: TextStyle(fontSize: 12, color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'UserMangment',
          ),
        ],
      ),
    );
  }
}

