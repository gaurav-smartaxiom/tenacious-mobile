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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
   
   bool _isPasswordVisible = false;
    bool _isChecked = false;
    bool isLoggedIn = false;

   String successMessage = '';
   String errorMessage = '';
// user login process------------------

Future<void>looo()async{

Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ScanDevicePage()),
  );


}

//   Future<void> Loginuser() async {
//     print("login");
    
//   // final String apiUrl = 'http://10.0.2.2:4000/api/v1/login';
//     final String apiUrl = loginApiUrl;
//     //print("apiUrl: $apiUrl");
//     final Map<String, String> requestBody = {
//       'email': _usernameController.text,
//       'password': _passwordController.text,
//     };

//     try {
//       print("try");
      
//       final response = await http.post(Uri.parse(apiUrl), body: requestBody);
//       print("res----------------------,$response");
//       final responseBody = response.body;
//       final token = response.body;
//        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
//        print("decodeToken---------->,$decodedToken");
//       // print("responseBody-----------------,$responseBody");
//       if (response.statusCode == 201) {
//         print("user login successfully");
//         //apply session-----------
//       final sharedPreferences = await SharedPreferences.getInstance();
//       print("session----------,$sharedPreferences");
//      sharedPreferences.setString('token', token);
//      sharedPreferences.setString('email', _usernameController.text);
//      sharedPreferences.setString('password', _passwordController.text);
//         setState(() {
//           successMessage = "User login successful";
//           errorMessage = ''; 
//         });
//           ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(successMessage),
//           ),
//         );
//       //  _usernameController.clear();
//       // _passwordController.clear();

//        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
//       //      Decode the JSON response to get the token
//   Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(
//     builder: (context) => DashboardPage(decodedToken: decodedToken),
//   ),
//   (route) => false, // This predicate will always return false
// );

//        } else {
//         setState(() {
//           errorMessage = "Login failed. Please check your credentials.";
//           successMessage = ''; 
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(successMessage != '' ? successMessage : errorMessage),
//           ),
//         );
//         print("Login failed. Status code: ${response.statusCode}");
//       }
//     } catch (error) {
//       setState(() {
//         errorMessage = "An error occurred. Please try again later.";
//         successMessage = ''; 
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(successMessage != '' ? successMessage : errorMessage),
//         ),
//       );

//       print("An error occurred: $error");
//     }
//   }

Future<void>forgotpassword() async

{

print("forgotpassword");


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
                  padding: EdgeInsets.only(top: 0.0), // Add padding to the top of the image
                  child: Image.asset(
                    'assets/download.png',
                    width: 800,
                    height: 150,
                  ),
                ),
SizedBox(height: 150),
Row(
      children: <Widget>[
        Expanded( // Use Expanded to make the TextFormField take up remaining space
          child: TextFormField(
            keyboardType:TextInputType.text,
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
                TextFormField(
                 // keyboardType: TextInputType.number,
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
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Remember me',
                      ),
                    ),
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          print("hello");
                          var username = _usernameController.text.toString();
                          var password = _passwordController.text.toString();
                          print("USERNAME: $username");
                          print("PASSWORD: $password");
                           //Loginuser();
                           looo();
                          
                          
                        },
                        child: Text('Sign in'),
                      ),
                    ),
                  ],
                ),
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: <Widget>[
    GestureDetector( // Wrap the forgetpassword? text with GestureDetector
      onTap: () {
        print("forgatpasswordsssss");

        forgotpassword();
        // Handle forget password click action here
        // For example, you can show a dialog or navigate to a password reset screen.
      },
      child: Padding(
        padding: EdgeInsets.only(top: 40.0  ), // Set the top padding here
        child: Text(
          "forgotpassword?",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ),
  ],
),

],

          ),
         
         
         ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3),
       // color: Colors.yellow, // Set the bottom bar background color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: "I Don't have an account? ",
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}