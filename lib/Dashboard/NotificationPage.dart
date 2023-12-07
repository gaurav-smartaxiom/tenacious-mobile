import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobileapp/Dashboard/WindowPage.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/userprofile.dart';
import 'package:mobileapp/Dashboard/AddDevicePage.dart';
import 'package:mobileapp/Dashboard/DashboardBox.dart';
import 'package:mobileapp/Dashboard/Dashboard.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/UserManagementPage.dart';

class NotificationPage extends StatefulWidget {

 final Map<String, dynamic> decodedToken;
 NotificationPage({required this.decodedToken});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int numberOfItems = 10; // Set the initial number of items
  TextEditingController searchController = TextEditingController();
  late List<String> itemList = [];
  late List<String> filteredList = [];
  late List<String> filteredList1 = [];
  late String mydata = '';
  int _selectedIndex = 0;
   // Changed to String type
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

if (index == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardPage(decodedToken: widget.decodedToken,)));
      } else if (index == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ShipmentPage(decodedToken: widget.decodedToken,)));
      } else if (index == 4) {
        // Navigate to UserProfilePage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 3) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage(decodedToken: widget.decodedToken,)));
      }
      else if (index == 5) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserManagementPage()));
      }
      else if(index==2)
      
      {
Navigator.of(context).push(MaterialPageRoute(
  builder: (context) => AddDevicePage(deviceUuid: '9876543210',decodedToken: widget.decodedToken,),
));
 // Pass the device UUID



      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Fetch shipments from the API when the widget is initialized
    loadSessionData().then((token) {
      fetchShipmentData(token);
    });

    searchController.addListener(onSearchChanged);
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

  Future<void> fetchShipmentData(String? token) async {
  final String backendUrl = shipment;

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

    // Extract deviceuuid values
    List<String> deviceUUIDs = items.expand<String>((shipment) {
      print("Shipment Name: ${shipment['shipmentName']}");

      // Extract trackers data if available
      if (shipment['trackers'] != null) {
        List<dynamic> trackers = shipment['trackers'];
        List<String> shipmentDeviceUUIDs = trackers.map<String>((tracker) {
          print("trackresssss, $tracker");
          print("Tracker Index: ${tracker['index']}");
          print("Tracker Timestamp: ${tracker['timestamp']}");

          // Extract data from tracker
          Map<String, dynamic> trackerData = tracker['data'];
          print("dtatata, $trackerData");

          // Check if 'deviceuuid' is not null before casting
          if (trackerData['deviceUUID'] != null) {
            print("Device UUID: ${trackerData['deviceUUID']}");
            setState(() {
              mydata = trackerData['deviceUUID'] as String;
              itemList.add(mydata); // Use add to add elements to the list
              onSearchChanged();
            });
            print("myyyyydataa,$mydata");
            return trackerData['deviceUUID'] as String;
          } else {
            print("Device UUID is null");
            return ''; // or any default value you want to use
          }
        }).toList();
        return shipmentDeviceUUIDs;
      } else {
        print("No trackers available for this shipment.");
        return [];
      }
    }).toList();
  
    print("Device UUIDs: $deviceUUIDs");

    // You can return the deviceUUIDs directly
    //return deviceUUIDs;
  } else {
    print("Error: ${response.statusCode}");
  }
}

void onSearchChanged() {
  setState(() {
    filteredList = itemList
        .where((item) =>
            item.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();
  });
  print("FilteredList: $filteredList");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notification Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: 30,
                            title: 'Section 1',
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: 20,
                            title: 'Section 2',
                          ),
                          PieChartSectionData(
                            color: Colors.yellow,
                            value: 50,
                            title: 'Section 3',
                          ),
                        ],
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 83,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // Handle the onChanged event here
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.format_list_numbered,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('${filteredList[index]}'),
                            onTap: () {
                              // Add your onTap logic here
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0, right: 20.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text('Status: Connected'),
                                Text('Last Connected: 2 mins ago'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 2, // Adjust the height of the divider as needed
                      color: Colors.grey,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
     BottomNavigationBarItem(
      icon: Icon(Icons.mail),
      label: 'UserMangment',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.blue,
  onTap: _onItemTapped,
),




    );
  }
}


