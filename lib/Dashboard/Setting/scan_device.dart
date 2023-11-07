import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class ScanDevicePage extends StatefulWidget {
  @override
  _ScanDevicePageState createState() => _ScanDevicePageState();
}

class _ScanDevicePageState extends State<ScanDevicePage> {
  String scannedData = 'Scan a device';
  bool isScanning = false;

  Future<void> scanDevice() async {
    setState(() {
      isScanning = true; // Set isScanning to true to show a loading indicator
    });

    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        setState(() {
          scannedData = result.rawContent;
          isScanning = false; // Set isScanning to false to hide the loading indicator
        });
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
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ScanDevicePage()));
}
