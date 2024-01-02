import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/Dashboard/TrackresAPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddShipmentPage extends StatefulWidget {
  final String shipmentName;

  const AddShipmentPage({Key? key, required this.shipmentName})
      : super(key: key);

  @override
  _AddShipmentPageState createState() => _AddShipmentPageState();
}

class _AddShipmentPageState extends State<AddShipmentPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Tracker Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: 320,
          height: 2000,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Selected Shipment: ${widget.shipmentName}',
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(height: 150),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "ShipmentName",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Location",
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Type'),
                  value: null,
                  items: ['Movable', 'Fixed'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle type selection
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      print('Selected Date: $selectedDate');
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () async {
                          var check = await SharedPreferences.getInstance();
                          final email = check.getString('email');
                          print("check email: $email");

                          // Always show the pop-up

                          // Only navigate to TrackresAPage if the condition is true
                          if (email != null &&
                              email == 'suraj.subramoniam@honeywell.com') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackresAPage()),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Unauthorized User'),
                                  content:
                                      Text('You are not authorized to create.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the pop-up
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: Text('Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
