import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:mobileapp/DeviceDetailPage.dart';
import 'package:mobileapp/DeviceDetailPage.dart';
import 'package:mobileapp/BluetoothDeviceModel.dart';
import 'ScanDetailPage.dart';

class ScanDevicePage extends StatefulWidget {
  @override
  _ScanDevicePageState createState() => _ScanDevicePageState();
}

class _ScanDevicePageState extends State<ScanDevicePage> {
  BluetoothDeviceModel? data;
  String scannedData = 'Scan a device';
  bool isScanning = false;
  String macAddress = '';
  Future<void> scanDevice() async {
    setState(() {
      isScanning = true;
    });

    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        setState(() {
          scannedData = result.rawContent;
          isScanning =
              false; // Set isScanning to false to hide the loading indicator
        });
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        print("Scanned Data: $scannedData");

        RegExp macAddressRegex = RegExp(r'MAC: (\S+)');
        RegExpMatch? match = macAddressRegex.firstMatch(scannedData);
        macAddress = match?.group(1) ?? 'Not found';
        print("MAC Address: $macAddress");
      } else {
        setState(() {
          scannedData = 'Scan failed: No barcode data found';
          isScanning = false;
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          scannedData = 'Camera permission was denied';
          isScanning = false;
        });
      } else {
        setState(() {
          scannedData = 'Error: $e';
          isScanning = false;
        });
      }
    }
  }
  void connectToDevice() {
    print("sssssssssssssssssssssssssssssssssss, ${macAddress}");

    final deviceId = macAddress;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailPage1(deviceId: deviceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Device"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isScanning)
              CircularProgressIndicator() // Show a loading indicator while scanning
            else
              Text(
                scannedData,
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanDevice,
              child: Text("Scan Device"),
            ),
            if (!isScanning && scannedData != 'Scan a device')
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Text("Scanned Data:"),
                        ),
                        TableCell(
                          child: Text(scannedData),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: connectToDevice,
              child: Text("Connect to Device"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ScanDevicePage()));
}
