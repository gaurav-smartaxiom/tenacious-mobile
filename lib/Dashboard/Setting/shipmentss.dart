import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
class ShipmentDetailsPage extends StatefulWidget {

  final int indexToReset;
  final String sensorName;
 final bool sensorState;
  final bool isActive1;

  ShipmentDetailsPage({
    required this.indexToReset,
    required this.sensorName,
   required this.sensorState,
    required this.isActive1,
  });


  @override
  _ShipmentDetailsPageState createState() => _ShipmentDetailsPageState();
}

class _ShipmentDetailsPageState extends State<ShipmentDetailsPage> {
  String shipmentName = '';
  String deviceUUID = '';
  String lastConnected = '2 mins ago';
  String battery = '40';
  String signal = '30';
DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    shipmentName=shipmentName;
   // deviceUUID=widget.sensorName; // Access the sensorName using widget

  loadSessionData().then((token) {
      fetchData(token);
    });

  }
 Future<String?> loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    final token = sharedPreferences.getString('token');

    print('Stored Email: $email');
    print('Stored Password: $password');
    print("token-------------$token");
    return token; // Return the token as a Future<String?>
  }

 Future<void> fetchData(String? token) async {
  final String backendUrl = shipment;
  final String shipmentID = '64e464f3eb12d5b4aa42453c'; // Replace with your actual shipment ID

  final response = await http.get(
    Uri.parse(backendUrl),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print('response, $response');
  print("Response Body: ${response.body}");
  print(response.statusCode == 200);

  if (response.statusCode == 200) {
    final List<dynamic> items = jsonDecode(response.body)['items'];

    // Find the item with the specified shipment ID
    final Map<String, dynamic>? selectedShipment = items.firstWhere(
      (shipment) => shipment['id'] == shipmentID,
      orElse: () => null,
    );

    print("Selected Shipment: $selectedShipment");

    if (selectedShipment != null) {
      // Extract shipment name and trackers for the selected shipment
       shipmentName = selectedShipment['shipmentName'] ?? '';
      List<dynamic> trackers = selectedShipment['trackers'] ?? [];

      print("Shipment Name: $shipmentName");
      print("Trackers: $trackers");

      for (var tracker in trackers) {
        print("Tracker Data: $tracker");
        deviceUUID = tracker['data']['serial_number'] ?? '';
        print("Device UUID: $deviceUUID");
        // Now you can use deviceUUID as needed
      }


     setState(() {
              shipmentName = shipmentName;
            deviceUUID=deviceUUID;
            });
    } else {
      print("Shipment ID $shipmentID not found in the response");
    }
  } else {
    print("Error: ${response.statusCode}");
    // Handle the error case
  }
}

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text section
            Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Icon(Icons.local_shipping, size: 24), // Replace with the appropriate icon
      SizedBox(width: 8), // Adjust the spacing between icon and text
    // Flexible(
//   child: Text(
//     shipmentName,
//     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//   ),
// ),
Expanded(
  child: Text(
    shipmentName,
    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  ),
)



    ],
  ),
),

            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
              ),
            ),
            // Map section (Replace with your map widget)
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.blue, // Replace with your map widget
              ),
            ),
            // Device Information section
       Padding(
  padding: const EdgeInsets.all(1.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(1.0),
        ),
        child: Text('Device UUID: $deviceUUID', style: TextStyle(fontSize: 10)),
      ),
       SizedBox(width: 2,),
      Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        //  borderRadius: BorderRadius.circular(1.0),
        ),
        child: Text('Last Connected: $lastConnected', style: TextStyle(fontSize:10)),
      ),
       SizedBox(width: 1,),
Container(
  padding: EdgeInsets.all(2.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(1.0),
  ),
  child: Row(
    children: [
      Text('Battery:', style: TextStyle(fontSize: 10)),
      SizedBox(width: 3.0), // Adjust the spacing between "Battery:" and icon
      Transform.rotate(
        angle: -9.4 / 2, // Rotate by 90 degrees (in radians)
        child: Icon(Icons.battery_full, size: 10.0), // Icon after the text
      ),
      SizedBox(width: 1.0), // Adjust the spacing between icon and value
      Text('$battery%', style: TextStyle(fontSize: 10)),
    ],
  ),
),
      SizedBox(width: 2,),
     Container(
  padding: EdgeInsets.all(5.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(1.0),
  ),
  child: Row(
    children: [
       // Assuming you want to use this icon
       // Adjust the spacing between icon and text
      Text('Signal:', style: TextStyle(fontSize: 10)),
      Icon(Icons.signal_cellular_4_bar, size: 10.0),
       Text(' $signal', style: TextStyle(fontSize: 10))
    ],
  ),
)
,
      // Add more device information as needed
    ],
  ),
),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Icon(Icons.picture_as_pdf_sharp, size: 15.0), // Replace with the appropriate icon
        SizedBox(width: 5.0),
        Text(
          'Download Report',
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    ),
    Row(
      children: [
        Text(
          'Download Calibration',
          style: TextStyle(fontSize: 10.0),
        ),
        SizedBox(width: 5.0),
        Icon(Icons.file_download, size: 15.0), // Replace with the appropriate icon
      ],
    ),
  ],
),




            // Calendar section
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _selectFromDate(context),
                    child: Row(
                      children: [
                        Text('From: ${DateFormat('dd-MM-yyyy').format(fromDate)}'),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _selectToDate(context),
                    child: Row(
                      children: [
                        Text('To: ${DateFormat('dd-MM-yyyy').format(toDate)}'),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle apply button press
                      print('From: ${DateFormat('dd-MM-yyyy').format(fromDate)}, To: ${DateFormat('dd-MM-yyyy').format(toDate)}');
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            ),

            // Sensor Data section
        Container(
              height: 200,
              color: Colors.yellowAccent,
             padding: EdgeInsets.all(8.0),
              //color: Colors.red,
              child:LineChart(

LineChartData(

minX: 0,
minY: 0,
maxX: 20,
maxY: 20,


lineBarsData: 
[


LineChartBarData(


spots: [



  FlSpot(0, 3),
                        FlSpot(0, 0),
                        FlSpot(2, 4),
                        FlSpot(3, 2),
                        FlSpot(4, 5),
                        FlSpot(5, 3),
                        FlSpot(6, 4),
                        FlSpot(15, 17),
                         FlSpot(17,20),
                          FlSpot(19,20),
                           FlSpot(20,20),
                        
],
isCurved:  true,

)

]

)



              ),
              ),
            
           SizedBox(height: 10,),
   Container(
  height: 200,
  color: Colors.white,
  child: SingleChildScrollView(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disable scrolling for the outer SingleChildScrollView
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apollo Premier, Vijay Nagar'),
                    SizedBox(height: 10,),
                   Row(
  children: [
    Transform.rotate(
      angle: -9.4 / 2, // Rotate by 90 degrees (in radians)
      child: Icon(Icons.battery_full, size: 12.0), // Rotated battery icon
    ),
    Text('20%   '),
    Icon(Icons.signal_cellular_4_bar, size: 12.0), // Network cell icon
    Text('18%   '),
    Icon(Icons.water, size: 12.0), // Humidity icon
    Text('27.95   '),
     Icon(Icons.thermostat, size: 12.0),
    Text('47.00   '),
    Text('00.00   '),
  ],
)

                  ],
                ),
              ),
              Expanded(
  child: Padding(
    padding: EdgeInsets.only(top: 25.0), // Adjust the top padding as needed
    child: Text(
      '10 Sep 2023 04:54',
      textAlign: TextAlign.right,
    ),
  ),
),

            ],
          ),
        );
      },
    ),
  ),
)






          ],
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
}

