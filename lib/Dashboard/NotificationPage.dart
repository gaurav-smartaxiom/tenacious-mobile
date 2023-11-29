
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int numberOfItems = 10; // Set the initial number of items
  TextEditingController searchController = TextEditingController();
  late List<String> itemList =[];
  late List<String> filteredList=[]; // Declare 'filteredList' as 'late'

  @override
  void initState() {
    super.initState();
    
   // 
    loadSessionData().then((token) {
    // Fetch shipments from the API when the widget is initialized
   fetchData(token);
 
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

Future<void> fetchData(String ?token) async {
final String backendUrl=Sensor;
  
  final response = await http.get(
        Uri.parse(backendUrl),
         headers: {
           'Authorization': 'Bearer $token',
         }
      );

      print('response, $response');
      print("Response Body: ${response.body}");
       print(response.statusCode == 200);

if (response.statusCode == 200) {
  final List<dynamic> data = jsonDecode(response.body);

  // Extract sensor names
  List<String> names = data.map((sensor) => sensor['sensorName']).cast<String>().toList();
  print("Sensor Names: $names");

  // Extract MAC addresses
  List<String> macAddresses = data.map((sensor) => sensor['mac_addr']).cast<String>().toList();
  //print("MAC Addresses: $macAddresses");


setState(() {
  itemList=macAddresses;
  onSearchChanged();
searchController.addListener(onSearchChanged);
  
});
print("item list,$itemList");
} else {
  print("Error: ${response.statusCode}");
}
}

 void onSearchChanged() {
  setState(() {
    filteredList = itemList
        .where((item) => item.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();
  });
print("tttttttttttttttttttttttttttt");
  print("FilteredList: $filteredList"); // Print the filtered list
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {},
                ),
              ),  
            ),
          ),
          // Add your ListView.builder here
       Expanded(
  child: ListView.builder(
    itemCount: filteredList.length,
    itemBuilder: (context, index) {
      // You can customize the items in the list
      print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print("FilteredList Length: ${filteredList.length}"); // Move the print statement inside the builder
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(filteredList[index]),
            onTap: () {
              // Add your onTap logic here
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text('Status: Connected'),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text('Last Connected: 2 mins ago'),
          ),
          Divider(), // Add a Divider between items
        ],
      );
    },
  ),
),

        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
