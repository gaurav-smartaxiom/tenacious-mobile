import 'package:flutter/material.dart';
//import 'package:bbbb/Dashboard/WindowPage.dart';
import 'package:mobileapp/Dashboard/WindowPage.dart';
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
class DashboardPage extends StatefulWidget {
 final Map<String, dynamic> decodedToken;
  DashboardPage({required this.decodedToken});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
 TextEditingController searchController = TextEditingController(); 
 String searchResult = ""; 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WindowPage()));
      } else if (index == 1) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShipmentPage()));
      } else if (index == 4) {
        // Navigate to UserProfilePage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()));
      } else if (index == 3) {
        // Navigate to NotificationPage
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
      }
      else if(index==2)
      
      {
Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDevicePage()));

      }
    });
  }
 
void initState() {
    super.initState();
    loadSessionData();
  }
 void loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    final token=sharedPreferences.getString('token');

    print('Stored Email: $email');
    print('Stored Password: $password');
    print("token-------------$token");
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
print("Decoded Token and welcome  to dashboard page----------->: ${widget.decodedToken}");
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0), // Top padding for the search bar
            child: Container(
              width: 500.0,
              height: 50, // Search bar ki width
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 2.0, // Border width
                ),
              ),
              padding: EdgeInsets.all(5.0), // Padding around the search bar
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey, // Icon color
                  ),
                  SizedBox(width: 10.0), // Spacing between icon and TextField
                  Expanded(
                     child: TextField(
                      controller: searchController,
                     // onSubmitted: _onSearchSubmitted, // Call this function when search is submitted
                      decoration: InputDecoration(
                        hintText: "Search", // Placeholder text
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none, // Text field ka border hide karein
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(searchResult), // Display the search result here
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
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.blue,
  onTap: _onItemTapped,
),
    );   
  }
}
