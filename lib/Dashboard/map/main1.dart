import 'package:flutter/material.dart';
import 'package:mobileapp/Dashboard/map/home_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: "/home",
      routes: {
        "/home": (context) => MainPageExample(),
        "/second": (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, "/home");
              },
              child: Text("another page"),
            ),
          ),
        ),
        //"/picker-result": (context) => LocationAppExample(),
        // "/search": (context) => SearchPage(),
      },
    );
  }
}

class Main1 extends StatefulWidget {
  @override
  _Main1State createState() => _Main1State();
}

class _Main1State extends State<Main1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: "/home1", // Set a different initial route if needed
      routes: {
        "/home1": (context) => MainPageExample(), // Define routes for Main1 class
        // Add more routes as needed
      },
    );
  }
}
