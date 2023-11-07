import 'package:flutter/material.dart';

class ShipmentPage extends StatefulWidget {
  @override
  _ShipmentPageState createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  final List<Shipment> allShipments =   [
        Shipment(
      title: 'Test shipment indore To... Movable',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
    Shipment(
      title: 'Test shipment',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
        Shipment(
      title: 'Test shipment2',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
        Shipment(
      title: 'Test shipment3',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
    Shipment(
      title: 'Test shipment4',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
    Shipment(
      title: 'Test shipment5',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
    Shipment(
      title: 'Test shipment6',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),
     Shipment(
      title: 'Test shipment7',
      deviceUUID: '9876543210',
      lastConnected: '2 mins Ago',
    ),


    // Add more shipments here
  ];

  List<Shipment> filteredShipments = [];

  @override
  void initState() {
    super.initState();
    filteredShipments = List.from(allShipments);
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