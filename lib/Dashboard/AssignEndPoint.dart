import 'package:flutter/material.dart';
import 'package:mobileapp/Dashboard/ErrorPage.dart';
import 'package:mobileapp/Dashboard/Success.dart';

class AssignEndPoint extends StatefulWidget {
  const AssignEndPoint({Key? key}) : super(key: key);

  @override
  _AssignEndPointState createState() => _AssignEndPointState();
}

class _AssignEndPointState extends State<AssignEndPoint> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AssignEndPointPage'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Assign EndPoint",
              ),
              items: [
                DropdownMenuItem<String>(
                  value: 'movable',
                  child: Text('Movable'),
                ),
                DropdownMenuItem<String>(
                  value: 'fixed',
                  child: Text('Fixed'),
                ),
              ],
              iconSize: 45,
              focusColor: Colors.grey,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                print("Try Again with selected value: $selectedValue");
                if(selectedValue=='movable')
                {
                  print("if");
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> SuccessPage()));
                }
                else
                {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> ErrorPage())); 
                }
                
              },
              child: Container(
                width: 300,
                height: 45,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Assign",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
