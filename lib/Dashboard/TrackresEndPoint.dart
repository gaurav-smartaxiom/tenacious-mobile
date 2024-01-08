import 'package:flutter/material.dart';
import 'package:mobileapp/Dashboard/AssignEndPoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerEndPointPage extends StatefulWidget {
  const TrackerEndPointPage({Key? key}) : super(key: key);

  @override
  _TrackerEndPointState createState() => _TrackerEndPointState();
}

class _TrackerEndPointState extends State<TrackerEndPointPage> {
  String? selectedValue;
  TextEditingController tempMinController = TextEditingController();
  TextEditingController tempMaxController = TextEditingController();
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
                        controller: tempMinController,
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
                        controller: tempMaxController,
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
              onTap: () async {
                print("Try Again");

                var check = await SharedPreferences.getInstance();
                var email = check.getString('email');

Navigator.push(context,MaterialPageRoute(builder: (context)=> AssignEndPoint()));

//                 if (email != null &&
//                     email == 'suraj.subramoniam@honeywell.com') {
//                   print("Superadmin");
// Navigator.push(context,MaterialPageRoute(builder: (context)=> AssignEndPoint()));
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Authorized Superadmin'),
//                         content:
//                             Text('only Superadmin is authorized to create.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(); // Close the pop-up
//                             },
//                             child: Text('OK'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
              },
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
