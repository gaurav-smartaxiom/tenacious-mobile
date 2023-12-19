import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mobileapp/Dashboard/WindowPage.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/userprofile.dart';
import 'package:mobileapp/Dashboard/AddDevicePage.dart';
import 'package:mobileapp/Dashboard/DashboardBox.dart';
import 'package:mobileapp/Dashboard/Dashboard.dart';
import 'package:mobileapp/Dashboard/UserManagementPage.dart';

class ShipmentDetailsPage extends StatefulWidget {
  // final int indexToReset;
  // final String sensorName;
  // final bool sensorState;
  // final bool isActive1;
  final String ShipmentName;

  final Map<String, dynamic> decodedToken;

  ShipmentDetailsPage(
      {
      //required this.indexToReset,
      //required this.sensorName,
      //required this.sensorState,
      //required this.isActive1,
      required this.ShipmentName,
      required this.decodedToken});

  @override
  _ShipmentDetailsPageState createState() => _ShipmentDetailsPageState();
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
  } else if (percentage <= 35) {
    return BatteryLevel.mediumLow;
  } else if (percentage <= 50) {
    return BatteryLevel.medium;
  } else if (percentage <= 75) {
    return BatteryLevel.mediumHigh;
  } else if (percentage <= 95) {
    return BatteryLevel.mediumHigh;
  } else {
    return BatteryLevel.high;
  }
}

Icon getBatteryIcon(int percentage, {double iconSize = 1}) {
  Color iconColor;

  switch (getBatteryLevel(percentage)) {
    case BatteryLevel.low:
      iconColor = Colors.red;
      return Icon(MdiIcons.batteryAlert, color: iconColor, size: iconSize);
    case BatteryLevel.mediumLow:
      iconColor = Colors.green;
      return Icon(MdiIcons.battery20, color: iconColor, size: iconSize);
    case BatteryLevel.medium:
      // iconColor = Colors.yellow;
      return Icon(MdiIcons.battery50, size: iconSize);
    case BatteryLevel.mediumHigh:
      iconColor = Colors.yellow;
      return Icon(MdiIcons.battery80, color: iconColor, size: iconSize);
    case BatteryLevel.high:
      iconColor = Colors.blue;
      return Icon(MdiIcons.battery, color: iconColor, size: iconSize);
  }
}

class _ShipmentDetailsPageState extends State<ShipmentDetailsPage> {
  String shipmentName = '';
  int percentage = 50;
  String deviceUUID = '';
  String lastConnected = '12 year ago';
  // String battery = '40';
  String signal = '30';
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String pickupLocation = '';
  String pickupDate = '';
  String dateOnly = '';
  int _selectedIndex = 0;

List<Marker> marker = [];
  List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(37.42796133580664, -122.085749655962),
        infoWindow: InfoWindow(title: "my location"))
  ];



  @override
  void initState() {
    super.initState();
    shipmentName = widget.ShipmentName;
    //shipmentName = shipmentName;
    // deviceUUID=widget.sensorName; // Access the sensorName using widget

    loadSessionData().then((token) {
      fetchShipmentData(token);
    });

    marker.addAll(_list);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashboardPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ShipmentPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 3) {
        // Navigate to UserProfilePage
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 2) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotificationPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 5) {
        // Navigate to NotificationPage
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserManagementPage()));
      } else if (index == 6) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddDevicePage(
            deviceUuid: '9876543210',
            decodedToken: widget.decodedToken,
          ),
        ));
        // Pass the device UUID
      }
    });
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MMMM d, y').format(dateTime);
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

  Future<void> fetchShipmentData(String? token) async {
    final String backendUrl = shipment;
    final String shipmentID = '64e464f3eb12d5b4aa42453c';

    final response = await http.get(
      Uri.parse(backendUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('response, $response');
    print("Response Body: ${response.body}");
    print(response.statusCode == 200);

    if (response.statusCode == 200) {
      final List<dynamic> items = jsonDecode(response.body)['items'];

      // Find the item with the specified shipment ID
      final Map<String, dynamic>? selectedShipment = items.firstWhere(
        (shipment) => shipment['id'] == shipmentID,
        orElse: () => null,
      );

      print("Selected Shipment: $selectedShipment");

      if (selectedShipment != null) {
        //shipmentName = selectedShipment['shipmentName'] ?? '';
        pickupLocation = selectedShipment['pickupLocation'] ?? '';
        pickupDate = selectedShipment['pickupDate'] ?? '';
        print(pickupLocation);
        try {
          dateOnly = formatDate(DateTime.parse(pickupDate));
        } catch (e) {
          print('Error parsing date: $pickupDate');
          print('Exception: $e');
        }

        List<dynamic> trackers = selectedShipment['trackers'] ?? [];

        print("Shipment Name: $shipmentName");
        print("Trackers: $trackers");
        for (var tracker in trackers) {
          print("Tracker Data: $tracker");
          deviceUUID = tracker['data']['serial_number'] ?? '';
          print("Device UUID: $deviceUUID");
        }
        setState(() {
          shipmentName = shipmentName;
          deviceUUID = deviceUUID;
          pickupLocation = pickupLocation;
          pickupDate = pickupDate;
          dateOnly = dateOnly;
        });
      } else {
        print("Shipment ID $shipmentID not found in the response");
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> downloadReport() async {
    print("Downloaded Report");
  }

  Future<void> file_download() async {
    print("fileDownload");
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackres Deatails'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/new.png', width: 32),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shipmentName,
                            style: TextStyle(
                                fontSize: 20, ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Align the content to the start (left) of the Row
                    children: [
                      Flexible(
                        // Use Flexible instead of Expanded
                        child: Padding(
                          padding: EdgeInsets.only(left: 0,right: 0), // Add left padding
                          child: Text(
                            "It is a long established fact that a reader will be distracted by the qqqq readable content of a page when looking at its layout.",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.blue,
                  child: Row(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(37.42796133580664, -122.085749655962),
                            zoom: 10,
                          ),
mapType: MapType.normal,
                             markers: Set<Marker>.of(marker),
                        ),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Text('Device UUID: $deviceUUID',
                        style: TextStyle(fontSize: 10)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 9),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      //  borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Text('Last Connected: $lastConnected',
                        style: TextStyle(fontSize: 10)),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Row(
                      children: [
                        Text('Battery:', style: TextStyle(fontSize: 10)),
                        //SizedBox(width: 1.0), // Adjust the spacing between "Battery:" and icon
                        Transform.rotate(
                          angle: -9.4 / 2, // Rotate by 90 degrees (in radians)
                          child: getBatteryIcon(percentage, iconSize: 11),
                        ),
                        //SizedBox(width: 1.0), // Adjust the spacing between icon and value
                        Text('$percentage%', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  SizedBox(
                      // width: 1,
                      ),
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Row(
                      children: [
                        // Assuming you want to use this icon
                        // Adjust the spacing between icon and text
                        Text('Signal:', style: TextStyle(fontSize: 9)),
                        Icon(Icons.signal_cellular_4_bar, size: 8.0),
                        Text(' $signal', style: TextStyle(fontSize: 9))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         downloadReport();
            //       },
            //       child: Row(
            //         children: [
            //           Icon(Icons.picture_as_pdf_sharp, size: 15.0),
            //           SizedBox(width: 5.0),
            //           Text(
            //             'Download Calibration',
            //             style: TextStyle(fontSize: 10.0),
            //           ),
            //         ],
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         file_download();
            //       },
            //       child: Row(
            //         children: [
            //           Text(
            //             'Download Calibration',
            //             style: TextStyle(fontSize: 10.0),
            //           ),
            //           SizedBox(width: 5.0),
            //           Icon(Icons.file_download, size: 15.0),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            // Calendar section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white), // Add border styling if needed
                  // borderRadius: BorderRadius.(12.0), // Add border radius if needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _selectFromDate(context),
                      child: Row(
                        children: [
                          Text(
                              'From: ${DateFormat('dd-MM-yyyy').format(fromDate)}'),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _selectToDate(context),
                      child: Row(
                        children: [
                          Text(
                              'To: ${DateFormat('dd-MM-yyyy').format(toDate)}'),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          print(
                            'From: ${DateFormat('dd-MM-yyyy').format(fromDate)}, To: ${DateFormat('dd-MM-yyyy').format(toDate)}',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Apply',
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              color: Colors.white,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pickupLocation.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pickupLocation,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Transform.rotate(
                                      angle: -9.4 /
                                          2, // Rotate by 90 degrees (in radians)
                                      child: getBatteryIcon(percentage,
                                          iconSize: 20), // Rotated battery icon
                                    ),
                                    Text('$percentage%'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.signal_cellular_4_bar,
                                        size: 18.0), // Network cell icon
                                    Text('18%   '),
                                    // Icon(Icons.water,
                                    //  size: 12.0), // Humidity icon
                                    // Text('27.95   '),
                                    // Icon(Icons.thermostat, size: 12.0),
                                    // Text('47.00   '),
                                    // Text('00.00   '),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 55.0),
                              child: Text(
                                dateOnly,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.window),
            label: 'Window',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bus.png', // Replace with the path to your image asset
              width: 35, // Adjust the width as needed
              height: 35, // Adjust the height as needed
            ),
            label: 'Shipment',
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
}
