import 'package:flutter/material.dart';
import 'package:mobileapp/Dashboard/TrackresEndPoint.dart';

class TrackresAPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackresAPage> {
  String?selectedValue;
  TextEditingController trackerController = TextEditingController();
  TextEditingController tempMinController = TextEditingController();
  TextEditingController tempMaxController = TextEditingController();
  TextEditingController humidityMinController = TextEditingController();
  TextEditingController humidityMaxController = TextEditingController();
  TextEditingController accelerationMinController = TextEditingController();
  TextEditingController accelerationMaxController = TextEditingController();
  TextEditingController geofenceController = TextEditingController();



void CreateTrackresPoint() async{

print(selectedValue.toString());
print(accelerationMaxController.text);
Navigator.push(context,MaterialPageRoute(builder: (context)=>TrackerEndPointPage()));

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(' Assign Tracker'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(       
         child: Center(
          child:Container(
          width: 320,
          //height: 2000,
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            // Align at the top
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tracker' ,style: TextStyle(  fontWeight: FontWeight.bold,),),
            Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
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
              Text('Temperature',style: TextStyle(  fontWeight: FontWeight.bold,)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tempMinController,
                      decoration: InputDecoration(labelText: 'Min'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: tempMaxController,
                      decoration: InputDecoration(labelText: 'Max'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Humidity',style: TextStyle(  fontWeight: FontWeight.bold,)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: humidityMinController,
                      decoration: InputDecoration(labelText: 'Min'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: humidityMaxController,
                      decoration: InputDecoration(labelText: 'Max'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Acceleration',style: TextStyle(  fontWeight: FontWeight.bold,)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: accelerationMinController,
                      decoration: InputDecoration(labelText: 'Min'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: accelerationMaxController,
                      decoration: InputDecoration(labelText: 'Max'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text('Geofence',style: TextStyle(  fontWeight: FontWeight.bold,)),
              TextField(
                controller: geofenceController,
                decoration: InputDecoration(labelText: 'Enter Geofence'),
              ),
                //   SizedBox(height: 80),
                //   Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       width: 300,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           print("hello");
                //         },
                //         child: Text('Assign'),
                //       ),
                //     ),
                //   ],
                // ),
            ],
          ),
          )
        ),
      ),





bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => {
                CreateTrackresPoint()



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
)

    );
  }
}
