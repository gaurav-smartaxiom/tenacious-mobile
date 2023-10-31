import 'package:flutter/material.dart';

class DashboardBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500.0, // Box ki width
        height: 50.0, // Box ki height
        decoration: BoxDecoration(
          color: Colors.white, // Box ka background color (Blue)
          borderRadius: BorderRadius.circular(10.0), // Box ke corners ki radius
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.white.withOpacity(0.5),
          //     spreadRadius: 3,
          //     blurRadius: 1,
          //     offset: Offset(0, 10), // Box ki shadow ka offset
          //   ),
          // ],
          // border: Border.all(
          //   color: Colors.blue, // Border color (Blue)
          //   width: 2.0, // Border width
          // ),
        ),
        child: Center(
          child: Text(
            "Dashboard Box",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Text color white
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
