import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceModel {
  final BluetoothDevice device;
  final String name;
  final String id;
  final int rssi;
  bool isConnected; // Remove 'final'

  BluetoothDeviceModel({
    required this.device,
    required this.name,
    required this.id,
    required this.rssi,
    this.isConnected = false,
  });
}