import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AddShipmentPage extends StatelessWidget {
  final String shipmentName;

  const AddShipmentPage({Key? key, required this.shipmentName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Shipment'),
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
                Text('Selected Shipment: $shipmentName',style: TextStyle(color: Colors.blue),),
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
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
