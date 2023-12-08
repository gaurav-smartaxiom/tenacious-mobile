import 'package:flutter/material.dart';

class NoShipmentPage extends StatefulWidget {
  @override
  _NoShipmentPageState createState() => _NoShipmentPageState();
}

class _NoShipmentPageState extends State<NoShipmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Shipment Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'No Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
