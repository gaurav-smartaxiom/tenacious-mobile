import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AddShipmentPage extends StatefulWidget {
  final String shipmentName;

  const AddShipmentPage({Key? key, required this.shipmentName}) : super(key: key);

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
        title: Text('Add Shipment'),
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
                  controller: _dateController, // Use the TextEditingController
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      // Handle the selected date
                      print('Selected Date: $selectedDate');
                        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate); 
                         setState(() {
                          _dateController.text = formattedDate; // Update the text
                        });
                         // Update the text
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
                        onPressed: () {
                          print("hello");
                        
                       
                       
                         
                          
                          
                        },
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
    _dateController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }
}
