import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/HomePage.dart';
//import 'package:bbbb/login and signup/signup.dart';
import 'dart:convert';
//import 'package:bbbb/api_endPoint/api_endpoints.dart';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
import 'package:mobileapp/login and signup/signup.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobileapp/Dashboard/Dashboard.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/Dashboard/Setting/firmware.dart';
import 'package:mobileapp/Dashboard/Setting/scan_device.dart';
import 'package:flutter/gestures.dart';

class OTPPage extends StatefulWidget {
  @override
  OTPPagePageState createState() => OTPPagePageState();
}

class OTPPagePageState extends State<OTPPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //TextEditingController _usernameController = TextEditingController();
  
  TextEditingController _NewpasswordController = TextEditingController();


  bool _isPasswordVisible = false;
  bool _NewisPasswordVisible = false;
  bool _isChecked = false;
  bool isLoggedIn = false;
  bool _isCheckedD=false;
http.Response? response;
  String successMessage = '';
  String errorMessage = '';
   late BuildContext dialogContext; // Added variable to store dialog context
 // bool isCheckboxChecked = false;
// user login process------------------

// Future<void>looo()async{

// Navigator.of(context).push(
//     MaterialPageRoute(builder: (context) => ScanDevicePage()),
//   );

// }
// Future<void> showTermsAndConditionsDialog(bool value) async {
//   print("rrrrrrrrrrrrrr");
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       dialogContext = context; // Store dialog context
//       return AlertDialog(
//         title: Text('Terms and Conditions'),
//         content: SingleChildScrollView(
//           child: Text(
//             'These are the terms and conditions. Please read them carefully and accept to proceed.',
//           ),
//         ),
//         actions: <Widget>[
//          TextButton(
//   onPressed: () {
//     // Set _isChecked to false
//     setState(() {
//       _isChecked = false;
//     });

//     // Dismiss the dialog
//     Navigator.of(context).pop();
//   },
//   child: Text('Cancel'),
// ),

//           TextButton(
//             onPressed: () {
//               // Perform the login after accepting terms
             
//               Navigator.of(context).pop(); // Dismiss the dialog
//               performLogin(); // Pass the response to performLogin
            
//             },
//             child: Text('Accept'),
//           ),
//         ],
//       );
//     },
//   );
// }





//  Future<void> performLogin() async {
//     print("accpet");
//   //Loginuser();
//   }

//   Future<void> loginWithTermsCheck( bool _isChecked) async {
//     print("wwwwwwwwwwwwww");
//     // Show the terms and conditions dialog
//     await showTermsAndConditionsDialog(_isChecked);
//   }


  Future<void> Loginuser() async {
    print("login");
  
    //final String apiUrl = 'http://10.0.2.2:4000/api/v1/login';
    final String apiUrl = login;
    //print("apiUrl: $apiUrl");
    final Map<String, String> requestBody = {
     // 'email': _usernameController.text,
     
    };

    try {
      print("try");

      final response = await http.post(Uri.parse(apiUrl), body: requestBody);
      print("res----------------------,$response");
      // final responseBody = response.body;
      // Extract the token value from the parsed JSON
      final Map<String, dynamic> responseBody = json.decode(response.body);
      // Parse the JSON response
      String token = responseBody['token'];
    
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode("{'token': $token}");
      print("decodeToken---------->,$decodedToken");
      print("responseBody-----------------,$responseBody");
      if (response.statusCode == 201) {
        print("user login successfully");
        //apply session-----------
        final sharedPreferences = await SharedPreferences.getInstance();
        print("session----------,$sharedPreferences");
        sharedPreferences.setString('token', token);
        //sharedPreferences.setString('email', _usernameController.text);
        
        setState(() {
          successMessage = "User login successful";
          errorMessage = '';
          
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
          ),
        );
         // _usernameController.clear();
        

        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
        //      Decode the JSON response to get the token
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(decodedToken: decodedToken),
          ),
          (route) => false, // This predicate will always return false
        );
      } else {
        setState(() {
          errorMessage = "Login failed. Please check your credentials.";
          successMessage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage != '' ? successMessage : errorMessage),
          ),
        );
        print("Login failed. Status code: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        errorMessage = "An error occurred. Please try again later.";
        successMessage = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage != '' ? successMessage : errorMessage),
        ),
      );

      print("An error occurred: $error");
    }
  }














  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      body: Center(
        child: Container(
          width: 300,
          height: 2000,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.0), // Add padding to the top of the image
                  child: Image.asset(
                    'assets/download.png',
                    width: 800,
                    height: 150,
                  ),
                ),
               
                
                SizedBox(height: 80),
              Container(
  width: double.infinity, // Set the width to match the parent
  padding: EdgeInsets.all(1), // Add padding to the container
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blueGrey), // Add border
    borderRadius: BorderRadius.circular(10), // Optional: Add border radius for rounded corners
  ),
  child: TextFormField(
    // keyboardType: TextInputType.number,
    controller: _NewpasswordController,
    obscureText: !_NewisPasswordVisible,
    decoration: InputDecoration(
      labelText: "OTP",
      //prefixIcon: Icon(Icons.lock),
      border: InputBorder.none, // Hide the default border
    ),
  ),
),



SizedBox(height: 80,),

                Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Container(
      width: 240,
      child: ElevatedButton(
        onPressed: () {
         
          // Check if the checkbox is checked
        },
        child: Text('Enter')
      ),
    ),
  ],
),

                
              ],
            ),
          ),
        ),
      ),

//   bottomNavigationBar: Container(
 
// ),



    );
  }
}
