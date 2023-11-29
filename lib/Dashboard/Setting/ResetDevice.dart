import 'package:flutter/material.dart';

class ResetDevice extends StatefulWidget {
  final int indexToReset;
  final String sensorName;
  final bool sensorState;
  final bool isActive1;

  ResetDevice({
    required this.indexToReset,
    required this.sensorName,
    required this.sensorState,
    required this.isActive1,
  });

  @override
  ResetDeviceState createState() => ResetDeviceState();
}

class ResetDeviceState extends State<ResetDevice> with SingleTickerProviderStateMixin {
  TextEditingController _trackerIdController = TextEditingController();
  TextEditingController _serialNumberController = TextEditingController();
  TextEditingController _batteryStatusController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _lastConnectController = TextEditingController();

  bool _isTrackerIdVisible = false;
  bool _isSerialNumberVisible = false;
  bool _isBatteryStatusVisible = false;
  bool _isStatusVisible = false;
  bool _isLastConnectVisible = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleTrackerIdVisibility() {
    setState(() {
      _isTrackerIdVisible = !_isTrackerIdVisible;
    });
  }

  void _toggleSerialNumberVisibility() {
    setState(() {
      _isSerialNumberVisible = !_isSerialNumberVisible;
    });
  }

  void _toggleBatteryStatusVisibility() {
    setState(() {
      _isBatteryStatusVisible = !_isBatteryStatusVisible;
    });
  }

  void _toggleStatusVisibility() {
    setState(() {
      _isStatusVisible = !_isStatusVisible;
    });
  }

  void _toggleLastConnectVisibility() {
    setState(() {
      _isLastConnectVisible = !_isLastConnectVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Device'),
        centerTitle:  true,
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 2000,
          padding: EdgeInsets.only(top: 150,left: 10),
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildExpandableField(
                  "Tracker ID",
                  Icons.track_changes,
                  _trackerIdController,
                  _isTrackerIdVisible,
                  _toggleTrackerIdVisibility,
                ),
               Divider(),
                _buildExpandableField(
                  "Serial Number",
                  Icons.format_list_numbered,
                  _serialNumberController,
                  _isSerialNumberVisible,
                  _toggleSerialNumberVisibility,
                ),
                   Divider(),
                _buildExpandableField(
                  "Battery Status",
                  Icons.battery_full,
                  _batteryStatusController,
                  _isBatteryStatusVisible,
                  _toggleBatteryStatusVisibility,
                ),
                   Divider(),
                _buildExpandableField(
                  "Status",
                  Icons.check_circle,
                  _statusController,
                  _isStatusVisible,
                  _toggleStatusVisibility,
                ),
                   Divider(),
                _buildExpandableField(
                  "Last Connect",
                  Icons.access_time,
                  _lastConnectController,
                  _isLastConnectVisible,
                  _toggleLastConnectVisibility,
                ),
                   Divider(),
              ],
            ),
          ),





          
        ),
        
      ),



       bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed, // Fixed type bottom navigation bar
  showSelectedLabels: false, // Selected label ko hide karein
  showUnselectedLabels: false, // Unselected labels ko hide karein
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.window),
      label: 'Window',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_shipping),
      label: 'Shipment',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.devices_other),
      label: 'Add_Devices',
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
  // currentIndex: _selectedIndex,
  // selectedItemColor: Colors.blue,
  // onTap: _onItemTapped,
),

    );







    
  }

  Widget _buildExpandableField(
    String labelText,
    IconData icon,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  //Icon(icon),
                  SizedBox(width: 8),
                 Text(
  labelText,
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    //color: Colors.grey, // Set the color to white
    // Alternatively, you can use grey color
     color: Colors.grey,
  ),
),

                ],
              ),
            ),
          IconButton(
  icon: Icon(
    Icons.keyboard_arrow_down,
    size: 30,
    color: Colors.grey, // Set the color to white
  ),
  onPressed: () {
    setState(() {
      toggleVisibility();
    });
  },
),
 ],
   ),
        if (isVisible)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
             border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
