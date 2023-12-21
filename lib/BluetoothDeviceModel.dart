import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceModel {
  final BluetoothDevice device;
  final String name;
  final String id;
  final int rssi;
  bool isConnected;
  String macAddress;
   // Remove 'final'
 
  BluetoothDeviceModel({
    required this.device,
    required this.name,
    required this.id,
    required this.rssi,
    required this.macAddress,
    this.isConnected = false,
    
  });
}