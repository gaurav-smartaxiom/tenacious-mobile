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
  //TextEditingController _usernameController = TextEditingController()
  TextEditingController _NewpasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _NewisPasswordVisible = false;
  bool _isChecked = false;
  bool isLoggedIn = false;
  bool _isCheckedD=false;
http.Response? response;
  String successMessage = '';
  String errorMessage = '';
 
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
                      top: 0.0), 
                  child: Image.asset(
                    'assets/download.png',
                    width: 800,
                    height: 150,
                  ),
                ),
               
                
                SizedBox(height: 80),
              Container(
  width: double.infinity, 
  padding: EdgeInsets.all(1), 
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blueGrey), 
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
         
        },
        style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
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
