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
import 'OtpFile.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}
class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _NewpasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _NewisPasswordVisible = false;
  bool _isChecked = false;
  bool isLoggedIn = false;
  bool _isCheckedD = false;
  http.Response? response;
  String successMessage = '';
  String errorMessage = '';
  late BuildContext dialogContext; 
  Future<void> EnterOtp() async {
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OTPPage()), 
    );
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
                      top: 0.0), 
                  child: Image.asset(
                    'assets/download.png',
                    width: 800,
                    height: 150,
                  ),
                ),
                SizedBox(height: 150),
                Row(
                  children: <Widget>[
                    Expanded(
                     
                      child: TextFormField(
                        
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Old Password",
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
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  // keyboardType: TextInputType.number,
                  controller: _NewpasswordController,
                  obscureText: !_NewisPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "New_Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_NewisPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _NewisPasswordVisible = !_NewisPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          EnterOtp();
                        },
                        child: Text('Sign in'),
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
