import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LoadingScreen.dart';
//import 'package:bbbb/login and signup/loginpage.dart';
import 'package:mobileapp/login and signup/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/Dashboard/Dashboard.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Your app's theme configuration
      ),
      home: const AppLoader(), // Show the loading screen initially
    );
  }
}

class AppLoader extends StatefulWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  @override
  void initState() {
    super.initState();
    
    // Delay the transition to the home page after 5 seconds
    Future.delayed(const Duration(seconds: 10), () {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      checkLoginStatus();
    });
    
  }
  void checkLoginStatus() async {
    final sharedPreferences = await SharedPreferences.getInstance();
   // final  token = sharedPreferences.getString('token');
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
 String? token = sharedPreferences.getString('token');
Map<String, dynamic> decodedToken = token != null ? JwtDecoder.decode(token) : {};
    print("decodeToken---------->,$decodedToken");
    if (token != null && email != null && password != null) {
      // User is already logged in, navigate to the dashboard page.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardPage(decodedToken: decodedToken,), // Replace with your DashboardPage
        ),
      );
    } else {
      // User is not logged in, navigate to the login page.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(), // Replace with your LoginPage
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return  LoadingScreen();
  }
}
