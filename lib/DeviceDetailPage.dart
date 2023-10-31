// DeviceDetailPage.dart
import 'package:flutter/material.dart';
import 'BluetoothDeviceModel.dart';
//import 'package:bbbb/controller/blue.dart';
import 'package:mobileapp/controller/blue.dart';
import 'package:mobileapp/DFUUpdateScreen.dart';
//import 'package:bbbb/DFUUpdateScreen.dart';

class DeviceDetailPage extends StatefulWidget {
  final BluetoothDeviceModel device;

  DeviceDetailPage({required this.device});

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Name: ${widget.device.name ?? 'Unknown'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Device ID: ${widget.device.id}'),
            SizedBox(height: 10),
            Text('RSSI: ${widget.device.rssi}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleConnection();
              },
              child: Text(widget.device.isConnected
                  ? 'Disconnect from Device'
                  : 'Connect to Device'),
            ),
            SizedBox(height: 20),
            Text(
              'Connection Status: ${widget.device.isConnected ? 'Connected' : 'Not Connected'}',
              style: TextStyle(
                fontSize: 16,
                color: widget.device.isConnected ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20),
            // Add the "Start DFU Update" button here
            ElevatedButton(
             onPressed: _handleDFUUpdate,
              child: Text('Start DFUUpdate'),
            ),
          ],
        ),
      ),
    );
  }
void _handleDFUUpdate() {
  if (widget.device.isConnected) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DFUUpdateScreen(deviceId: widget.device.id),
      ),
    );
  } else {
    // Handle the case where the device is not connected
    print('Device not connected');
  }
}





  void _handleConnection() async {
    print("device");
    print(widget.device);
    if (widget.device.isConnected) {
      await BluetoothController.disconnectFromDevice(widget.device);
      // Update UI immediately after disconnection
      setState(() {
        widget.device.isConnected = false;
      });
    } else {
      bool isConnected =
          await BluetoothController.connectToDevice(widget.device);
      setState(() {
        widget.device.isConnected = isConnected;
      });
    }
  }

// void startDFUUpdate() async 
// {
//   print("sssssssssssss");

//   try {
//     // Call the method to start DFU update from BluetoothController
//     bool dfuUpdateStarted = await BluetoothController.startDFUUpdate(widget.device);

//     if (dfuUpdateStarted) {
//       // Update UI or show a message that DFU update has started
//       print('DFU Update Started for device ID: ${widget.device.id}');
      
//       // Check if DFU update is completed
//       bool dfuUpdateCompleted = await showDialog(
//         context: context, // Assuming this method is part of a widget class
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('DFU Update Completed'),
//             content: Text('DFU update for device ID ${widget.device.id} completed successfully.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true); // Return true if DFU update is completed
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );

//       if (dfuUpdateCompleted == true) {
//         // Do any additional actions after DFU update is completed
//         print('DFU Update Completed Message Shown');
//       }
//     } else {
//       // Handle the case where DFU update couldn't be started
//       print('Error starting DFU Update for device ID: ${widget.device.id}');
//     }
//   } catch (e) {
//     print('Error during DFU update: $e');
//   }
// }

}
