
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'add_shipment_page.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/userprofile.dart';
import 'package:mobileapp/Dashboard/AddDevicePage.dart';
import 'package:mobileapp/Dashboard/DashboardBox.dart';
import 'package:mobileapp/Dashboard/WindowPage.dart';

// void main() {
//   runApp(MaterialApp(home: ShipmentPage()));
// }

class ShipmentPage extends StatefulWidget {
  @override
  _ShipmentPageState createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  List<Shipment> allShipments = [];
  List<Shipment> filteredShipments = [];
   int _selectedIndex = 0;
  
 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WindowPage()));
      } else if (index == 1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShipmentPage()));
      } else if (index == 4) {
        // Navigate to UserProfilePage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 3) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
      }
      else if(index==2)
      
      {
Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => AddDevicePage(deviceUuid: '9876543210'),
));
 // Pass the device UUID



      }
    });
  }
  @override
  void initState() {
    super.initState();
    loadSessionData().then((token) {
      // Fetch shipments from the API when the widget is initialized
      fetchShipmentsFromAPI(token);
    });
  }

  Future<String?> loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    print('Token: $token');
    return token;
  }

  Future<void> fetchShipmentsFromAPI(String? token) async {
    final String backendUrl = 'http://192.168.29.11:4000/api/v1/shipments';

    print('Token: "$token"');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(backendUrl),
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvZmZpY2lhbEVtYWlsIjoic3VyYWouc3VicmFtb25pYW1AaG9uZXl3ZWxsLmNvbSIsImlkIjoiNjIyNzAyM2IzMDE3NDhmZTk4YTk1NGYwIiwidGVuYW50TmFtZSI6IkhvbmV5d2VsbEludGVybmF0aW9uYWwoSW5kaWEpUHZ0THRkIiwiaWF0IjoxNzAxMTYxNzg5LCJleHAiOjE3MDEyNDgxODl9.jXQC02IYQwvQ92b8_eMazfp0saoS4u4g_iCZ51JTlvc',
          },
        );

        print('response: $response');

        if (response.statusCode == 200) {
          try {
            final Map<String, dynamic> responseBody = json.decode(response.body);
            final List<dynamic> apiShipments = responseBody['items'];

            final List<Shipment> shipments = apiShipments
                .map((shipmentData) => Shipment.fromJson(shipmentData))
                .toList();

            for (Shipment shipment in shipments) {
              print("Shipment ID: ${shipment.id}");
              print("Shipment Name: ${shipment.shipmentName}");
              print("Shipment Length: ${shipment.length}");

              if (shipment.trackers != null && shipment.trackers.isNotEmpty) {
                print("Trackers:");
                for (Tracker tracker in shipment.trackers) {
                  print("Tracker ID: ${tracker.id}");
                  print("Tracker Name: ${tracker.trackerName}");
                  print("Device UUID: ${tracker.deviceUUID}");
                }
              } else {
                print("No trackers found for this shipment.");
              }
            }

            setState(() {
              allShipments = shipments;
              filteredShipments = List.from(allShipments);
            });
          } catch (e) {
            print('Error parsing JSON: $e');
          }
        } else {
          print("Error");
        }
      } catch (e) {
        print('Error fetching shipments: $e');
      }
    } else {
      print('Token is null');
    }
  }

  void performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredShipments = List.from(allShipments);
      } else {
        filteredShipments = allShipments
            .where((shipment) =>
                shipment.shipmentName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void selectShipment(Shipment shipment) {
    print('Selected Shipment Name: ${shipment.shipmentName}');
      Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddShipmentPage(shipmentName: shipment.shipmentName),
    ),
  );
  }

  void showShipmentDetails(Shipment shipment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Shipment Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Shipment Name: ${shipment.shipmentName}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                selectShipment(shipment);
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment Page'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
         SliverAppBar(
  pinned: true,
  centerTitle: true,
  floating: false,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
            border: Border.all(color: Colors.white), // Border color
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'SearchShipment..',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none, // Remove the default border
              ),
              onChanged: (value) {
                performSearch(value);
              },
            ),
          ),
        ),
      ),
    ),
  ),
),


   SliverList(
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      final shipment = filteredShipments[index];
      final NewShipmentType = shipment.shipmentType; // Corrected line
      return GestureDetector(
        onTap: () {
          showShipmentDetails(shipment);
        },
        child: ShipmentInfo(shipment: shipment, shipmentType: NewShipmentType),
      );
    },
    childCount: filteredShipments.length,
  ),
),








          
        ],
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
}
String _formatLastConnected(int timestamp) {
  DateTime lastConnected = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  Duration difference = DateTime.now().difference(lastConnected);

  if (difference.inDays > 365) {
    int years = difference.inDays ~/ 365;
    return '$years ${years > 1 ? 'years' : 'year'} ago';
  } else if (difference.inDays > 30) {
    int months = difference.inDays ~/ 30;
    return '$months ${months > 1 ? 'months' : 'month'} ago';
  } else {
    return timeago.format(lastConnected); // Use the timeago package for a human-readable format
  }
}



class Shipment {
  final String id;
  final String shipmentName;
  final String shipmentDesc;
  final String shipmentType;
  final String status;
  final String pickupLocation;
  final String pickupDate;
  final String destinationLocation;
  final String deliveryDate;
  final double length;
  final List<Tracker> trackers;
final bool isMovable;
  
  
  
  
  Shipment({
    required this.id,
    required this.shipmentName,
    required this.shipmentDesc,
    required this.shipmentType,
    required this.status,
    required this.pickupLocation,
    required this.pickupDate,
    required this.destinationLocation,
    required this.deliveryDate,
    required this.trackers,
    required this.length,
    required this.isMovable,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    try {
      final String id = json['id'] as String? ?? '';
      final String shipmentName = json['shipmentName'] as String? ?? '';
      final String shipmentDesc = json['shipmentDesc'] as String? ?? '';
      final String shipmentType = json['shipmentType'] as String? ?? '';
      final String status = json['status'] as String? ?? '';
      final String pickupLocation = json['pickupLocation'] as String? ?? '';
      final String pickupDate = json['pickupDate'] as String? ?? '';
      final String destinationLocation = json['destinationLocation'] as String? ?? '';
      final String deliveryDate = json['deliveryDate'] as String? ?? '';
      final double length = (json['length'] as num?)?.toDouble() ?? 0;
       final bool isMovable = json['isMovable'] as bool? ?? false; 
      final List<dynamic>? trackersData = json['trackers'] as List<dynamic>?;

      if (id.isEmpty || shipmentName.isEmpty || shipmentDesc.isEmpty || shipmentType.isEmpty || status.isEmpty) {
        throw FormatException("Invalid data in JSON");
      }

      List<Tracker> trackers = [];
     print("shipmenTyep----------------------------------------,$shipmentType");

      if (trackersData != null) {
        List<String> deviceUUIDs = [];

        for (Map<String, dynamic> trackerData in trackersData) {
          Tracker tracker = Tracker.fromJson(trackerData);

          print('TrackerData: $trackerData');
          print('Tracker object: ${tracker.toJson()}');

          String? deviceUUID = tracker.deviceUUID;

          print('DeviceUUIDDddddddddddddddddddddd: $deviceUUID');

          if (deviceUUID != null) {
            print("iffffffffffffffff");
            deviceUUIDs.add(deviceUUID);
          } else {
            print('DeviceUUID is null for tracker: ${tracker.id}');
          }
          tracker.deviceUUID = deviceUUID; // Assign device UUID to the tracker
    trackers.add(tracker);
        }
      }

      return Shipment(
        id: id,
        shipmentName: shipmentName,
        shipmentDesc: shipmentDesc,
        shipmentType: shipmentType,
        status: status,
        pickupLocation: pickupLocation,
        pickupDate: pickupDate,
        destinationLocation: destinationLocation,
        deliveryDate: deliveryDate,
        trackers: trackers,
        length: length,
        isMovable: isMovable
      );
    } catch (e) {
      throw FormatException("Error parsing JSON: $e");
    }
  }
}

class Tracker {
  final int index;
  final String id;
  final String previousHash;
  final int timestamp;
  final String trackerName;
  final TrackerData data;
  String? deviceUUID;

  Tracker({
    required this.index,
    required this.previousHash,
    required this.timestamp,
    required this.data,
    required this.id,
    required this.trackerName,
    this.deviceUUID,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    try {
      return Tracker(
        index: json['index'],
        trackerName: json['trackerName'] as String? ?? '',
        id: json['id'] as String? ?? '',
        previousHash: json['previousHash'] as String? ?? '',
        timestamp: json['timestamp'] as int? ?? 0,
        deviceUUID: json['data']['deviceUUID'] as String?,
        data: TrackerData.fromJson(json['data'] ?? {}),
      );
    } catch (e) {
      throw FormatException("Error parsing JSON: $e");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'id': id,
      'previousHash': previousHash,
      'timestamp': timestamp,
      'trackerName': trackerName,
      'data': data.toJson(),
      'deviceUUID': deviceUUID,
    };
  }
}

class TrackerData {
  final String clientId;
  final String macAddr;
  final String mfgName;
  final String modelName;
  final String serialNumber;
  final String swVer;
  final String bootRomVer;
  final String firmware;
  final String? deviceUUID;

  TrackerData({
    required this.clientId,
    required this.macAddr,
    required this.mfgName,
    required this.modelName,
    required this.serialNumber,
    required this.swVer,
    required this.bootRomVer,
    required this.firmware,
    required this.deviceUUID,
  });

  factory TrackerData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return TrackerData(
      clientId: data['client_id'] ?? '',
      macAddr: data['mac_addr'] ?? '',
      mfgName: data['mfg_name'] ?? '',
      modelName: data['model_name'] ?? '',
      serialNumber: data['serial_number'] ?? '',
      swVer: data['sw_ver'] ?? '',
      bootRomVer: data['boot_rom_ver'] ?? '',
      firmware: data['firmware'] ?? '',
      deviceUUID: data['deviceUUID'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'macAddr': macAddr,
      'mfgName': mfgName,
      'modelName': modelName,
      'serialNumber': serialNumber,
      'swVer': swVer,
      'bootRomVer': bootRomVer,
      'firmware': firmware,
      'deviceUUID': deviceUUID,
    };
  }
}

Map<String, dynamic> trackerToJson(Tracker tracker) {
  return {
    'index': tracker.index,
    'id': tracker.id,
    'previousHash': tracker.previousHash,
    'timestamp': tracker.timestamp,
    'trackerName': tracker.trackerName,
    'data': tracker.data.toJson(),
    'deviceUUID': tracker.deviceUUID,
  };
}
class ShipmentInfo extends StatelessWidget {
  final Shipment shipment;
  final String shipmentType; // Corrected line

  ShipmentInfo({required this.shipment, required this.shipmentType});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(1),
      child: ListTile(
        title: Row(
          children: [
 Icon(
  (() {
    print("shipmentType----------------------------------------, $shipmentType");

    if (shipmentType == 'Movable') {
      print("if");
      // Your logic for shipmentType being 'Movable'
      return Icons.local_shipping;
    } else {
      print("else");
      // Your logic for shipmentType not being 'Movable'
      return Icons.location_on;
    }
  })(),
  size: 30,
),

            SizedBox(width: 8, height: 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${shipment.shipmentName}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Text('${shipment.shipmentType}'),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text("DeviceUUID:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    '${shipment.trackers.isNotEmpty ? shipment.trackers.last.deviceUUID ?? 'N/A' : 'N/A'}',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text("Last Connected:", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 3),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    '${shipment.trackers.isNotEmpty ? _formatLastConnected(shipment.trackers.last.timestamp) : 'N/A'}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


