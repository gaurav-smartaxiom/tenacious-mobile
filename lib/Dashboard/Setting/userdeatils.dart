

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ConfrompasswordController = TextEditingController();
  TextEditingController _OrgnazationController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfrompasswordVisible = false;
  bool _isAlertsEnabled = false;
  bool _isDailyEnabledReports = false;
  Map<String, bool> shipmentCheckboxes = {};
String filter = '';
Map<String, bool> selectedShipments = {};
Shipment? selectedShipment;
 List<Shipment> allShipments = [];
  List<Shipment> filteredShipments = [];
List<String> roleOptions = ['Admin', 'User'];
String selectedUserRole = 'User';
  List<String> shipments = []; // Replace this with your shipment data
List<String> getFilteredShipments(String query) {
  return shipments.where((shipment) {
    return shipment.toLowerCase().contains(query.toLowerCase());
  }).toList();
}
  @override
  void initState() {
    super.initState();
    // Fetch shipments from the API when the widget is initialized
    fetchShipmentsFromAPI();
  }

Future<void> fetchShipmentsFromAPI() async {
  final String shipmentId = '6232ce73b5b181a9e9d93643';
  final String backendUrl = 'http://192.168.29.43:4000/api/v1/shipments';
  final sharedPreferences = await SharedPreferences.getInstance();
 final String? token = sharedPreferences.getString('token'); // Use String? instead of String




print('Tokennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn: "$token"');

  if (token != null) {
    try {
      final response = await http.get(
        Uri.parse(backendUrl),
        headers: {
           'Authorization': 'Bearer ', // Use the token directly
        // 'Authorization': 'Bearer $token',

        }
      );

      print('response, $response');
      print("Response Body: ${response.body}");
      print(response.statusCode == 200);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final List<dynamic> apiShipments = responseBody['items'];

          final List<Shipment> shipments = apiShipments
              .map((shipmentData) => Shipment.fromJson(shipmentData))
              .toList();

          setState(() {
            allShipments = shipments;
            filteredShipments = List.from(allShipments);
          });
          print(",qqqqqqqqqqqqqqqqqqqqqqqqqqqq,$filteredShipments");
        } catch (e) {
          // Handle any exceptions or errors that occur during JSON parsing
          print('Error parsing JSON: $e');
        }
      } else {
        print("Error");
        // Handle the case where the server returns an error status code
        // You can add error handling logic here
      }
    } catch (e) {
      // Handle any exceptions or errors that occur during the HTTP request
      print('Error fetching shipments: $e');
    }
  } else {
    // Handle the case where the token is null
    print('Token is null');
  }
}







void _registerUser() {
  print("register");
  final String role = selectedUserRole; // Replace with your logic to get the selected user role
  final String username = _usernameController.text;
  final String email = _EmailController.text;
  final String password = _passwordController.text;
  final String confirmPassword = _ConfrompasswordController.text;
  final String organization = _OrgnazationController.text;
  final String? MyShipnets = selectedShipment?.shipmentName;
final bool enableDailyReports = _isDailyEnabledReports;
final bool enableAlerts = _isAlertsEnabled;
  print(enableDailyReports);
 print(role);
 print(username);
 print(email);
 print(password);
 print(confirmPassword);
 print(organization);
 print(MyShipnets);
 print(enableDailyReports);
 print("rrrrrrrrr,$enableAlerts");
  // Now, you can send this data to your backend API using HTTP requests
  // Make an HTTP POST request to your API endpoint with this data
  // Example using the 'http' package:

  // Map<String, dynamic> userData = {
  //   'role': role,
  //   'username': username,
  //   'email': email,
  //   'password': password,
  //   'confirmPassword': confirmPassword,
  //   'organization': organization,
  //   'selectedShipments': selectedShipments,
  //   'enableDailyReports': enableDailyReports,
  //   'enableAlerts': enableAlerts,
  // };
  // final response = await http.post('your_api_endpoint', body: userData);

  // Handle the response from the API and show appropriate feedback to the user.
}






void _onShipmentSelected(String shipment) {
  print("Selected shipment: $shipment");
  
  // Check if the shipment is selected in the shipmentCheckboxes map
   final checkboxValue = shipment;
  print(checkboxValue);
   if (checkboxValue != null && checkboxValue == true) {
    // Shipment is selected
    print("Selected shipment: $shipment");
    // Perform any desired actions here
  }
}

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isDailyEnabledReports ? "Disable Daily Report?" : "Enable Daily Report?"),
          content: Text(_isDailyEnabledReports
              ? "Do you want to disable the daily report?"
              : "Do you want to enable the daily report?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  _isDailyEnabledReports = !_isDailyEnabledReports;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
void _showConfirmationDialogg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isAlertsEnabled ? "Disable Daily Report?" : "Enable Daily Report?"),
          content: Text(_isAlertsEnabled
              ? "Do you want to disable the daily report?"
              : "Do you want to enable the daily report?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  _isAlertsEnabled = !_isAlertsEnabled;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text('Add new User.'),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String choice) {
            // Handle menu item selection here
            if (choice == 'Admin') {
              setState(() {
                selectedUserRole = 'Admin'; // Update the selected role
              });
            } else if (choice == 'User') {
              setState(() {
                selectedUserRole = 'User'; // Update the selected role
              });
            }
          },
          icon: Icon(Icons.person), // Add the user icon as the dropdown trigger
          itemBuilder: (BuildContext context) {
            return ['Admin', 'User'].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    ),



      body: Center(
        child: Container(
          width: 400,
          height: 700,
          padding: EdgeInsets.all(20),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: Colors.black,
          //     width: 1.0,
          //   ),
          // ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _EmailController,
                        decoration: InputDecoration(
                          labelText: "EmailID",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ConfrompasswordController,
                  obscureText: !_isConfrompasswordVisible,
                  decoration: InputDecoration(
                    labelText: "ConfromPassword",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isConfrompasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isConfrompasswordVisible = !_isConfrompasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _OrgnazationController,
                  decoration: InputDecoration(
                    labelText: "Orgnazation",
                    prefixIcon: Icon(Icons.business),
                  ),
                ),



            SizedBox(height: 20), // Add spacing
     Container(
                  height: 400, // Adjust the height to accommodate the content
                  width: 400,
                 decoration: BoxDecoration(
    border: Border.all(
      color: Colors.greenAccent, // Border color
      width: 1.0, // Border width
    ),
  ),
                  child: Column(
                    children: [
                     Container(
  height: 50, // Adjust the height as needed
  color: Colors.white, // Set the background color
  padding: EdgeInsets.all(10), // Add padding for the search bar
  child: TextField(
    decoration: InputDecoration(
      labelText: '',
      hintText: "select shipment",
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (value) {
      setState(() {
        filter = value;
        print(value);
        final shipment=value;
         _onShipmentSelected(shipment);

      });
    },
  ),
),

                 
                   Expanded(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: filteredShipments.length,
    itemBuilder: (context, index) {
      final shipment = filteredShipments[index];

      // Access the properties of Shipment and convert them to lowercase
      final shipmentName = shipment.shipmentName.toLowerCase();
      final shipmentDesc = shipment.shipmentDesc.toLowerCase();

      if (shipmentName.contains(filter.toLowerCase()) || shipmentDesc.contains(filter.toLowerCase())) {
        return CheckboxListTile(
          title: Text(shipment.shipmentName),
          subtitle: Text(shipment.shipmentDesc),
          value: selectedShipment == shipment,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedShipment = shipment;
                //_onShipmentSelected(shipment);
              } else {
                selectedShipment = null;
              }
            });
          },
        );
      } else {
        return Container();
      }
    },
  ),
),

                    ],
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(right: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('DailyEnableReports'),
                      Switch(
                        value: _isDailyEnabledReports,
                        onChanged: (value) {
                          _showConfirmationDialog();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Enable Alerts'),
                      Switch(
                        value: _isAlertsEnabled,
                        onChanged: (value) {
                          _showConfirmationDialogg(
                            
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          print("hello");
                          _registerUser();
                          // Navigate to another page or perform an action
                        },
                        child: Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ), 
    );
    
  }


  
}
class Shipment {
  final String id;
  final String shipmentName;
  final String shipmentDesc;

  Shipment({
    required this.id,
    required this.shipmentName,
    required this.shipmentDesc,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id'],
      shipmentName: json['shipmentName'],
      shipmentDesc: json['shipmentDesc'],
    );
  }
}