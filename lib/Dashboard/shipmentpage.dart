import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    // Fetch shipments from the API when the widget is initialized
    fetchShipmentsFromAPI();
  }

Future<void> fetchShipmentsFromAPI() async {
  final String shipmentId = '6232ce73b5b181a9e9d93643';
  final String backendUrl = 'http://192.168.29.43:4000/api/v1/shipments';
  // final String backendUrl = 'http://192.168.29.43:4000/api/v1/shipments/$shipmentId';
//192.168.29.43
  final sharedPreferences = await SharedPreferences.getInstance();
  final token = sharedPreferences.getString('token');

  if (token != null) {
    // print(token);
    // Decode the JWT token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Now you can access the claims in the decoded token
    // print("Decoded Token: $decodedToken");

    try {
      // final response = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer $token',
      // });
    final parsedToken =jsonDecode(token);
    final TOKEN =  parsedToken;
    print("TOKEN-----44, $TOKEN, $backendUrl" );
    final response = await http.get(Uri.parse(backendUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvZmZpY2lhbEVtYWlsIjoiZ2F1cmF2QHNtYXJ0YXhpb20uY29tIiwiaWQiOiI2Mzc0ZDU3YzAyYTMwNmZjNjUwMTM4MGUiLCJ0ZW5hbnROYW1lIjoiSG9uZXl3ZWxsSW50ZXJuYXRpb25hbChJbmRpYSlQdnRMdGQiLCJpYXQiOjE2OTk0MzkzNzAsImV4cCI6MTY5OTUyNTc3MH0.g8GvEpWWN4AeIjzFon8j26H6S2XTqroHxI8f24zsshg',
    });
    
    print('response, $response');
      // final response = await http.get(
      //   Uri.parse(backendUrl),
      //   headers: {
      //     'Authorization': 'Bearer $token', // Send the token in the header
      //   },
      // );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> apiShipments = json.decode(response.body);
        final List<Shipment> shipments =
            apiShipments.map((shipment) => Shipment.fromJson(shipment)).toList();

        setState(() {
          allShipments = shipments;
          filteredShipments = List.from(allShipments);
        });
      } else {
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
                shipment.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
              Text('Shipment Name: ${shipment.title}'),
              Text('Device UUID: ${shipment.deviceUUID}'),
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

  void selectShipment(Shipment shipment) {
    // Handle the selection of the shipment here
    // You can access the shipment's details like shipment.title and shipment.deviceUUID
    print('Selected Shipment Name: ${shipment.title}');
    print('Selected Device UUID: ${shipment.deviceUUID}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Shipments',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  performSearch(value);
                },
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredShipments.length,
              itemBuilder: (context, index) {
                final shipment = filteredShipments[index];
                return GestureDetector(
                  onTap: () {
                    showShipmentDetails(shipment);
                  },
                  child: ShipmentInfo(shipment: shipment),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(), // Add dividers between list items
            ),
          ],
        ),
      ),
    );
  }
}

class Shipment {
  final String title;
  final String deviceUUID;
  final String lastConnected;

  Shipment({
    required this.title,
    required this.deviceUUID,
    required this.lastConnected,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      title: json['title'],
      deviceUUID: json['deviceUUID'],
      lastConnected: json['lastConnected'],
    );
  }
}

class ShipmentInfo extends StatefulWidget {
  final Shipment shipment;

  ShipmentInfo({required this.shipment});

  @override
  _ShipmentInfoState createState() => _ShipmentInfoState();
}

class _ShipmentInfoState extends State<ShipmentInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.directions_car),
        title: Text(widget.shipment.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device UUID: ${widget.shipment.deviceUUID}'),
            Text('Last Connected: ${widget.shipment.lastConnected}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ShipmentPage()));
}


