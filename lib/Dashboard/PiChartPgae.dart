import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum BatteryLevel { low, mediumLow, medium, mediumHigh, high }

class PIcharPage extends StatefulWidget {
  @override
  PIcharPageState createState() => PIcharPageState();
}

class PIcharPageState extends State<PIcharPage> {
  double networkPercentage = 50;
  final double batteryPercentage = 50;
  final double temperaturePercentage = 30;
  final double accelerationPercentage = 80;
  final double humidityPercentage = 60;
  final double geofencePercentage = 70;

  int _selectedIndex = 0;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
        updateNetworkPercentage();
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void updateNetworkPercentage() {
    switch (_connectivityResult) {
      case ConnectivityResult.none:
        networkPercentage = 0;
        break;
      case ConnectivityResult.mobile:
        networkPercentage = 50;
        break;
      case ConnectivityResult.wifi:
        networkPercentage = 100;
        break;
      default:
        networkPercentage = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BatteryLevel getBatteryLevel(int percentage) {
    if (percentage <= 20) {
      return BatteryLevel.low;
    } else if (percentage <= 50) {
      return BatteryLevel.mediumLow;
    } else if (percentage <= 75) {
      return BatteryLevel.medium;
    } else if (percentage <= 95) {
      return BatteryLevel.mediumHigh;
    } else {
      return BatteryLevel.high;
    }
  }

  IconData getBatteryIcon(int percentage) {
    switch (getBatteryLevel(percentage)) {
      case BatteryLevel.low:
        return MdiIcons.batteryAlert;
      case BatteryLevel.mediumLow:
        return MdiIcons.battery20;
      case BatteryLevel.medium:
        return MdiIcons.battery50;
      case BatteryLevel.mediumHigh:
        return MdiIcons.battery80;
      case BatteryLevel.high:
        return MdiIcons.battery;
    }
  }

  List<PieChartSectionData> _generateNetworkData() {
    return [
      PieChartSectionData(
        value: networkPercentage,
        title: 'Network',
        color: Colors.blue,
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> _generateBatteryData() {
    return [
      PieChartSectionData(
        value: batteryPercentage,
        title: 'Battery',
        color: Colors.green,
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> _generateTemperatureData() {
    return [
      PieChartSectionData(
        value: temperaturePercentage,
        title: 'Temperature',
        color: Colors.red,
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> _HumidityData() {
    return [
      PieChartSectionData(
        value: humidityPercentage,
        title: 'Humidity',
        color: Colors.purple,
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> _GeofenceData() {
    return [
      PieChartSectionData(
        value: geofencePercentage,
        title: 'Geofence',
        color: Colors.teal,
        radius: 50,
      ),
    ];
  }

  List<PieChartSectionData> _accelerationData() {
    return [
      PieChartSectionData(
        value: accelerationPercentage,
        title: 'Acceleration',
        color: Colors.orange,
        radius: 50,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> networkData = _generateNetworkData();
    List<PieChartSectionData> batteryData = _generateBatteryData();
    List<PieChartSectionData> temperatureData = _generateTemperatureData();
    List<PieChartSectionData> HumidityData = _HumidityData();
    List<PieChartSectionData> GeofenceData = _GeofenceData();
    List<PieChartSectionData> accelerationData = _accelerationData();
    double totalPercentage = networkPercentage +
        accelerationPercentage +
        humidityPercentage +
        geofencePercentage +
        batteryPercentage +
        temperaturePercentage;

    return Scaffold(
      appBar: AppBar(
        title: Text('PICHARTPAge'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 380,
              height: 400,
              child: PieChart(
                PieChartData(
                    sections: networkData +
                        batteryData +
                        temperatureData +
                        HumidityData +
                        GeofenceData +
                        accelerationData),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildTotalItem('Total:', totalPercentage),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MobileNetwork(Icons.signal_cellular_alt,  'mobile', Colors.blue, 40),
                Battery(getBatteryIcon(batteryPercentage.toInt()),'Battery', Colors.green,
                    40),
              Temprature(MdiIcons.thermometer, 'Temperature', Colors.red, 40),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Humidity(MdiIcons.targetVariant,'Acceleration', Colors.orange, 40),
                Acceleration(MdiIcons.waterPercent,'Humniduty', Colors.purple, 40),
                Geofence(MdiIcons.mapMarkerRadius,'Geofence', Colors.teal, 40),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.window),
            label: 'Window',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bus.png',
              width: 35,
              height: 35,
            ),
            label: 'Shipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget MobileNetwork(IconData icon, String label, Color color, double iconSize) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        color: Colors.red[200],
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text('$label'),
         Text('${_getValueByIcon(icon)}%'), // Display the label (e.g., 'mobile') here
    ],
  );
}
  Widget Battery(IconData icon,String label, Color color, double iconSize) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: Colors.red[200],
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
        const SizedBox(height: 8),
         Text('$label'),
        Text('${_getValueByIcon(icon)}%'),
      ],
    );
  }

  Widget Temprature(IconData icon, String label, Color color, double iconSize) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        color: const Color.fromARGB(255, 128, 255, 145),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text('$label'),
      Text('${_getValueByIcon(icon)}%'), // Display the label (e.g., 'Temperature') here
    ],
  );
}

// Usage

  Widget Humidity(IconData icon, String label,Color color, double iconSize) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: Colors.green[200],
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
        const SizedBox(height: 8),
           Text('$label'),
        Text('${_getValueByIcon(icon)}%'),
      ],
    );
  }

  Widget Acceleration(IconData icon, String label, Color color, double iconSize) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: Colors.blue[200],
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
        const SizedBox(height: 8),
           Text('$label'),
        Text('${_getValueByIcon(icon)}%'),
      ],
    );
  }

  Widget Geofence(IconData icon, String label,Color color, double iconSize) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: Colors.greenAccent[200],
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
        const SizedBox(height: 8),
           Text('$label'),
        Text('${_getValueByIcon(icon)}%'),
      ],
    );
  }

  Widget _buildTotalItem(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$label ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('$value%'),
      ],
    );
  }

  double _getValueByIcon(IconData icon) {
    switch (icon) {
      case Icons.signal_cellular_alt:
        return networkPercentage;
      case MdiIcons.batteryAlert:
      case MdiIcons.battery20:
      case MdiIcons.battery50:
      case MdiIcons.battery80:
      case MdiIcons.battery:
        return batteryPercentage;
      case MdiIcons.thermometer:
        return temperaturePercentage;
      case MdiIcons.targetVariant:
        return accelerationPercentage;
      case MdiIcons.waterPercent:
        return humidityPercentage;
      case MdiIcons.mapMarkerRadius:
        return geofencePercentage;
      default:
        return 0.0;
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PIcharPage(),
  ));
}
