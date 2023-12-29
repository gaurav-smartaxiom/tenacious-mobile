import 'package:flutter/material.dart';

class TrackerEndPointPage extends StatefulWidget {
  const TrackerEndPointPage({Key? key}) : super(key: key);

  @override
  _TrackerEndPointState createState() => _TrackerEndPointState();
}

class _TrackerEndPointState extends State<TrackerEndPointPage> {
  String? selectedValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TreackerEndPoint'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text('TEMPERATURE',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'min'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 65,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 49.0),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'min'),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => {print("Try Again")},
              child: Container(
                width: 300,
                height: 45, // Added height
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
