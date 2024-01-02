import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:bbbb/Dashboard/WindowPage.dart';
import 'package:mobileapp/Dashboard/TrackresAPage.dart';
import 'package:mobileapp/Dashboard/shipmentpage.dart';
import 'package:mobileapp/Dashboard/NotificationPage.dart';
import 'package:mobileapp/Dashboard/userprofile.dart';
import 'package:mobileapp/Dashboard/AddDevicePage.dart';
import 'package:mobileapp/Dashboard/DashboardBox.dart';
//import 'package:mobileapp/HomePage.dart';
// import 'package:bbbb/Dashboard/shipmentpage.dart';
// import 'package:bbbb/Dashboard/NotificationPage.dart';
// import 'package:bbbb/Dashboard/userprofile.dart';
// import 'package:bbbb/Dashboard/DashboardBox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UserManagementPage.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:mobileapp/Dashboard/map/main1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
//import 'package:location/location.dart';

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic> decodedToken;
  DashboardPage({required this.decodedToken});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Completer<GoogleMapController> _Controller = Completer();
  int _selectedIndex = 0;
  String deviceUuid = '';
  TextEditingController searchController = TextEditingController();
  String searchResult = "";

  List<Marker> marker = [];
  List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(37.42796133580664, -122.085749655962),
        infoWindow: InfoWindow(title: "my location"))
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashboardPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ShipmentPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 3) {
        // Navigate to UserProfilePage
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 2) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotificationPage(
                  decodedToken: widget.decodedToken,
                )));
      } else if (index == 5) {
        // Navigate to NotificationPage
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserManagementPage()));
      } else if (index == 8) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddDevicePage(
            deviceUuid: '9876543210',
            decodedToken: widget.decodedToken,
          ),
        ));
        // Pass the device UUID
      }
    });
  }

  void initState() {
    super.initState();
    loadSessionData().then((token) {
      // Fetch shipments from the API when the widget is initialized
    });
    marker.addAll(_list);
    // double latitude = 22.728860; // replace with your desired latitude
    // double longitude = 75.758447; // replace with your desired longitude
    // updateMarker(latitude, longitude);
    // initializeLocation();
  }

  // void initializeLocation() async {
  //   print("ttttttttttttttttttttt");
  //   bool serviceEnabled = await Location().serviceEnabled();
  //   print("rrrrrrrrrrrrrrrrrrrrrrrr,$serviceEnabled");
  //   if (!serviceEnabled) {
  //     serviceEnabled = await Location().requestService();
  //     if (!serviceEnabled) {
  //       // Handle if the user doesn't enable location services.
  //     }
  //   }
  // }
  //   PermissionStatus permissionGranted = await Location().hasPermission();
  //   print("eeeeeeeeeeeeeeeeeee.$permissionGranted");
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await Location().requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       // Handle if the user doesn't grant location permissions.
  //     }
  //   }
  //   double latitude = 22.728860; // replace with your desired latitude
  //   double longitude = 75.758447; // replace with your desired longitude
  //   updateMarker(latitude, longitude);
  // }

  // void updateMarker(double latitude, double longitude) {
  //   if (latitude != null && longitude != null) {
  //     setState(() {
  //       marker.add(
  //         Marker(
  //           markerId: MarkerId('1'),
  //           position: LatLng(latitude, longitude),
  //           infoWindow: InfoWindow(title: 'My Location'),
  //         ),
  //       );
  //     });
  //   }
  // }

  Future<String?> loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    final token = sharedPreferences.getString('token');
    final storedUserLevel = sharedPreferences.getString('userLevel');
    print('Stored User Level: $storedUserLevel');

    print('Stored Email: $email');
    print('Stored Password: $password');
    print("token-------------$token");
    return token;
  }

// void _onSearchSubmitted(String query) async {
//   final googleMapsUrl = 'https://www.google.com/maps?q=${Uri.encodeQueryComponent(query)}';

//   if (await canLaunch(googleMapsUrl)) {
//     print("if");
//     await launch(googleMapsUrl);
//     setState(() {
//       // Update the search result when the URL is launched
//       searchResult = query;
//     });
//   } else {
//     print("else");
//     print('Could not launch $googleMapsUrl. Opening in a web browser instead.');

//     // If can't launch in Google Maps, try opening in a web browser
//     final webUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(query)}';
//     print(await canLaunch(webUrl));
//     if (await canLaunch(webUrl)) {
//       await launch(webUrl);
//       setState(() {
//         searchResult = query;
//       });
//     } else {
//       print("esle2");
//       print('Could not launch $webUrl in a web browser.');
//       // Handle the case where the URL cannot be launched, even in a web browser.
//     } 9920320932
//   }
// }

  @override
  Widget build(BuildContext context) {
//print("Decoded Token and welcome  to dashboard page----------->: ${widget.decodedToken}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                width: 500.0,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 130,
                  child: Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(37.42796133580664, -122.085749655962),
                            zoom: 10,
                          ),
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(marker),
                          compassEnabled: false,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _Controller.complete(controller);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Text(searchResult),
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
              'assets/bus.png', // Replace with the path to your image asset
              width: 35, // Adjust the width as needed
              height: 35, // Adjust the height as needed
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
          //  BottomNavigationBarItem(
          //   icon: Icon(Icons.message),
          //   label: 'User Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
