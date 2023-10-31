import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Loading Screen Background
            Container(
              color: Colors.white, 
            
            ),
            // Logo
            Center(
              child: Image.asset(
                'assets/images.png', // Replace with your logo image asset
                width: 100, // Set the width and height of your logo
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
