import 'package:flutter/material.dart';

class MasterPage extends StatefulWidget {
  final Map<String, dynamic> decodedToken;

  MasterPage({required this.decodedToken});

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Master page"),
      ),
      body: Center(
        child: Text("Welcome to the Master Page"),
      ),
    );
  }
}
