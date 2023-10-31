import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/state_manager.dart';
//import 'package:bbbb/BluetoothDeviceModel.dart';
import 'package:mobileapp/BluetoothDeviceModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import  'package:nordic_dfu/nordic_dfu.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
class BluetoothController extends GetxController {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
 bool dfuRunning = false;
  int? dfuRunningInx;
  
static Future<void> disconnectFromDevice(BluetoothDeviceModel device) async {
  try {
    print('Before disconnecting: ${device.device.connectionState}');
    await device.device.disconnect();
    print('After disconnecting: ${device.device.connectionState}');
    
    // Set the isConnected status to false
    device.isConnected = false;

    print('Disconnected successfully');
  } catch (e) {
    print('Error disconnecting from device: $e');
  }
}



//   static Future<bool>startDFUUpdate(BluetoothDeviceModel device) async {
    
//   try {

//     print('Starting DFU update for device ID: ${device.id}');

//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     if (result != null && result.files.isNotEmpty) {
//       File file = File(result.files.single.path!);

//       final dfuResult = await NordicDfu().startDfu(
//         device.id,
//         file.path,
//         fileInAsset: false,
//         onDeviceConnecting: (String address) {
//           debugPrint('Device Address: $address');
//         },
//         onProgressChanged: (
//           String deviceAddress,
//           int percent,
//           double speed,
//           double avgSpeed,
//           int currentPart,
//           int totalParts,
//         ) {
//           debugPrint('Device Address: $deviceAddress, Percent: $percent');
//           // Notify the progress to the UI or manage it accordingly
//           print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$percent");
//         },
//       );

//       if (dfuResult == dfuResult) {
//         print('DFU Update Completed Successfully');

        
//         return true;
//       } else {
//         print('DFU Update Failed: $dfuResult');
//         return false;
//       }
//     } else {
//       // User canceled file selection
//       print('File selection canceled');
//       return false;
//     }
//   } catch (e) {
//     print('Error starting DFU update: $e');
//     return false;
//   }
// }





   Future<void> scanDevice() async {
    try {
      // Start scanning for devices
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      // Delay for 5 seconds (or however long you want to scan)
      await Future.delayed(Duration(seconds: 5));

      // Stop scanning after the delay
      await FlutterBluePlus.stopScan();

      // Access the scan results
      FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
        // Do something with the results
      });
    } catch (e) {
      // Handle exceptions if any
      print('Error during scanning: $e');
    }
  }


  @override
  void onClose() {
    // Make sure to stop scanning when the controller is closed
    FlutterBluePlus.stopScan();
    super.onClose();
  }

static Future<bool> connectToDevice(BluetoothDeviceModel device) async {
  try {
    print("Connecting to device: ${device.name}");
    
    await device.device.connect();
    
    print("Connected to device: ${device.name}");
    
    return true; // Connection successful
  } catch (e) {
    print('Error connecting to device: $e');
    return false; // Connection failed
  }
}


  Stream<List<ScanResult>> get scanResultStream => FlutterBluePlus.scanResults;
}
