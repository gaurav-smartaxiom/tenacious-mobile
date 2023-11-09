import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobileapp/Dashboard/add_shipment_page.dart';

void main() {
  runApp(MaterialApp(home: ShipmentPage()));
}

class ShipmentPage extends StatefulWidget {
  @override
  _ShipmentPageState createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  List<Shipment> allShipments = [];
  List<Shipment> filteredShipments = [];
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
  final email = sharedPreferences.getString('email');
  final password = sharedPreferences.getString('password');
  final token = sharedPreferences.getString('token');

  print('Stored Email: $email');
  print('Stored Password: $password');
  print("token-------------$token");




  return token; // Return the token as a Future<String?>
}



  Future<void> fetchShipmentsFromAPI( String ?token) async {
  final String shipmentId = '6232ce73b5b181a9e9d93643';
  final String backendUrl = 'http://192.168.29.43:4000/api/v1/shipments';
//   final sharedPreferences = await SharedPreferences.getInstance();
//  final String? token = sharedPreferences.getString('token'); // Use String? instead of String



print('Tokennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn: "$token"');

  if (token != null) {
    try {
      final response = await http.get(
        Uri.parse(backendUrl),
        headers: {
            'Authorization': 'Bearer ', // Use the token directly
         //'Authorization': 'Bearer $token',

        }
      );

      print('response, $response');
      print("Response Body: ${response.body}");
      print(response.statusCode == 200);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final List<dynamic> apiShipments = responseBody['items'];

          final List<Shipment> shipments = apiShipments
              .map((shipmentData) => Shipment.fromJson(shipmentData))
              .toList();

          setState(() {
            allShipments = shipments;
            filteredShipments = List.from(allShipments);
          });
        } catch (e) {
          // Handle any exceptions or errors that occur during JSON parsing
          print('Error parsing JSON: $e');
        }
      } else {
        print("Error");
        // Handle the case where the server returns an error status code
        // You can add error handling logic here
      }
    } catch (e) {
      // Handle any exceptions or errors that occur during the HTTP request
      print('Error fetching shipments: $e');
    }
  } else {
    // Handle the case where the token is null
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
  // Handle the selection of the shipment here
  // You can access the shipment's details like shipment.shipmentName
  print('Selected Shipment Name: ${shipment.shipmentName}');

  // Navigate to the Add Shipment page
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
      pinned: true, // This makes the app bar fixed at the top
      title: Text('Shipment Page'),
      centerTitle: true,
      floating: false, // Set this to false to keep the app bar pinned
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Customize the background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
  decoration: InputDecoration(
    hintText: 'Search shipments...',  // Make sure the hint text fits within the TextField width
    prefixIcon: Icon(Icons.search),
    // Adjust the contentPadding to create more space
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),  // You can tweak these values
  ),
  onChanged: (value) {
    performSearch(value);
  },
)
        ),
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final shipment = filteredShipments[index];
          return GestureDetector(
            onTap: () {
              showShipmentDetails(shipment);
            },
            child: ShipmentInfo(shipment: shipment),
          );
        },
        childCount: filteredShipments.length,
      ),
    ),
  ],
)

    );
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
  final List<Tracker> trackers;

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
  });
factory Shipment.fromJson(Map<String, dynamic> json) {
  try {
    // Check if required fields exist and have the correct type
    final String id = json['id'] as String? ?? '';
    final String shipmentName = json['shipmentName'] as String? ?? '';
    final String shipmentDesc = json['shipmentDesc'] as String? ?? '';
    final String shipmentType = json['shipmentType'] as String? ?? '';
    final String status = json['status'] as String? ?? '';
    final String pickupLocation = json['pickupLocation'] as String? ?? '';
    final String pickupDate = json['pickupDate'] as String? ?? '';
    final String destinationLocation = json['destinationLocation'] as String? ?? '';
    final String deliveryDate = json['deliveryDate'] as String? ?? '';
    
    // Handle cases where data is missing or not of the correct type
    if (id.isEmpty || shipmentName.isEmpty || shipmentDesc.isEmpty || shipmentType.isEmpty || status.isEmpty) {
      throw FormatException("Invalid data in JSON");
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
      trackers: [], // Provide an empty list as the default value
    );
  } catch (e) {
    throw FormatException("Error parsing JSON: $e");
  }
}



}


class Tracker {
  final int index;
  final String previousHash;
  final int timestamp;
  final TrackerData data;

  Tracker({
    required this.index,
    required this.previousHash,
    required this.timestamp,
    required this.data,
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      index: json['index'],
      previousHash: json['previousHash'],
      timestamp: json['timestamp'],
      data: TrackerData.fromJson(json['data']),
    );
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

  TrackerData({
    required this.clientId,
    required this.macAddr,
    required this.mfgName,
    required this.modelName,
    required this.serialNumber,
    required this.swVer,
    required this.bootRomVer,
    required this.firmware,
  });

  factory TrackerData.fromJson(Map<String, dynamic> json) {
    return TrackerData(
      clientId: json['client_id'],
      macAddr: json['mac_addr'],
      mfgName: json['mfg_name'],
      modelName: json['model_name'],
      serialNumber: json['serial_number'],
      swVer: json['sw_ver'],
      bootRomVer: json['boot_rom_ver'],
      firmware: json['firmware'],
    );
  }
}

class ShipmentInfo extends StatelessWidget {
  final Shipment shipment;

  ShipmentInfo({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.directions_car),
        title: Text(shipment.shipmentName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pickup Location: ${shipment.pickupLocation}'),
            Text('Delivery Date: ${shipment.deliveryDate}'),
          ],
        ),
      ),
    );
  }
}
