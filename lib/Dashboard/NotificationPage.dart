import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Text('This is the Notification Page'),
      ),
    );
  }
}
