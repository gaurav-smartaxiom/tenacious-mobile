import 'package:flutter/material.dart';

class MainNavigation1 extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation1> {
  bool isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: () {
            setState(() {
              isSearchVisible = !isSearchVisible;
            });
          },
          heroTag: "MainMenuFab",
          mini: true,
          child: Icon(Icons.menu),
          backgroundColor: Colors.white,
        ),
        if (isSearchVisible) SearchBox(),
      ],
    );
  }
}

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          'Search',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search Demo'),
        ),
        body: Center(
          child: MainNavigation1(),
        ),
      ),
    );
  }
}
