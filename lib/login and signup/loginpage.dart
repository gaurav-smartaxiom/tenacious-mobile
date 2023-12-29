import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/Dashboard/PiChartPgae.dart';
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
import 'forgorpassword.dart';
import 'package:mobileapp/Dashboard/MasterPage.dart';
import 'package:mobileapp/Dashboard/PiChartPgae.dart';
import 'package:mobileapp/Dashboard/MasterDataPage.dart';
import 'package:mobileapp/Dashboard/Success.dart';
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
  bool _isCheckedD = false;
  http.Response? response;
  String successMessage = '';
  String errorMessage = '';
  String matchedUserLevel = '';
  late List<String> namelist = [];
  late BuildContext dialogContext; // Added variable to store dialog context
  Future<void> Loginuser() async {
    print("login");
    // final String apiUrl = 'http://20.198.123.163:4000/api/v1/login';
    final String apiUrl = login;
    //print("apiUrl: $apiUrl");
    final Map<String, String> requestBody = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };
    try {
      print("try");
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);
      print("res----------------------,$response");
     final Map<String, dynamic> responseBody = json.decode(response.body);
     print("responseBody----------------------120,$responseBody");
      String token = responseBody['token'];
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode("{'token': $token}");
      print("decodeToken---------->,$decodedToken");
      String Userid = decodedToken['id'];
      print("userid,$Userid");
      //print("responseBody-----------------,$responseBody");
      final UserAccessLevel = AccessUserLevel;
      print("userrrr,$UserAccessLevel");
      final NewUser = 'ADMIN';
      final Email = 'gaurav@smartaxiom.com';
      final urlWithParams =
          Uri.parse('$UserAccessLevel?email=$Email&userLevel=$NewUser');
      final AccessAllUser = await http.get(
        urlWithParams,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("AccessAllUser,$AccessAllUser");
      print(": ${AccessAllUser.body}");
      if (AccessAllUser.statusCode == 200) {
        final decodedBody = jsonDecode(AccessAllUser.body);
        final List<dynamic> permissionList = jsonDecode(AccessAllUser.body);
        for (var permission in permissionList) {
          final permissions = permission['permissions'];
          final checkUser = permission['levelname'];
          print("checklevelname,$checkUser");
          if (checkUser == NewUser) {
            matchedUserLevel =
                checkUser;
          }
        }
      } else {
        print("Error: ${AccessAllUser.statusCode}");
        print("Response body: ${AccessAllUser.body}");
      }
        print(response.statusCode);
      if (response.statusCode == 201) {
        print("user login successfully");
        //apply session-----------
        print(matchedUserLevel);
        final sharedPreferences = await SharedPreferences.getInstance();
        print("session----------,$sharedPreferences");
        sharedPreferences.setString('token', token);
        sharedPreferences.setString('email', _usernameController.text);
        sharedPreferences.setString('password', _passwordController.text);
        sharedPreferences.setString('userLevel', matchedUserLevel);
        setState(() {
          successMessage = "User login successful";
          errorMessage = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
          ),
        );
        _usernameController.clear();
        _passwordController.clear();
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
        //      Decode the JSON response to get the token
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => matchedUserLevel == 'SUPERADMIN'
                ? MasterPage(decodedToken: decodedToken)
                : DashboardPage(decodedToken: decodedToken),
          ),
          (route) => false,
        );

// ...
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
  void createAccount() {
    print("create");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage()),
    );
  }
  Future<void> forgotpassword() async {
    print("forgotpassword");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
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
                TextFormField(
                 
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

                            // Call the function when the checkbox is checked (value is true)
                            // if (_isChecked) {
                            //      loginWithTermsCheck(_isChecked); // Replace with your actual function call
                            // }
                          });
                          ;
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
                          var username = _usernameController.text.toString();
                          var password = _passwordController.text.toString();
                          print("USERNAME: $username");
                          print("PASSWORD: $password");
                          Loginuser();

                          // Check if the checkbox is checked
                          // if (!_isChecked) {
                          //   // Show message if the checkbox is not checked
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text('Please accept the terms and conditions. after then loggin My Application'),
                          //     ),
                          //   );
                          // } else {
                          //   // Proceed with the login process
                          //   loginWithTermsCheck(_isChecked);
                          // }
                        },
                        style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                        child: Text('Sign in'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      
                      onTap: () {
                        forgotpassword();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 40.0), // Set the top padding here
                        child: Text(
                          "Forgot password?",
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: "I Don't have an account? ",
                children: [
                  TextSpan(
                    text: 'Signup',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                   recognizer: TapGestureRecognizer()
                       ..onTap = () {
                        createAccount();
                      },
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
