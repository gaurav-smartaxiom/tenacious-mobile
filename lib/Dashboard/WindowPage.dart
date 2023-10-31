import 'package:flutter/material.dart';

class WindowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Window Page'),
      ),
      body: Center(
        child: Text('welcome to window page'),
      ),
    );
  }
}
