import 'package:flutter/material.dart';
//import 'package:bbbb/controller/blue.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/state_manager.dart';
import 'DeviceDetailPage.dart';
import 'BluetoothDeviceModel.dart';
import 'package:mobileapp/controller/blue.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
               Container(
  height: 100,
  width: double.infinity,
  color: Colors.blue,
  child: const Center(
    child: Text(
      "Bluetooth Nrf App....",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25, // Adjust the font size as needed
        color: Colors.white, // Set the text color
      ),
    ),
  ),
),

                const SizedBox(height: 10,),
                Center(
  child: Container(
    width: 200, // Set your desired width here
    child: ElevatedButton(
      onPressed: () {
        controller.scanDevice();
      },
      child: Text("Scan", style: TextStyle(color: Colors.yellow)),
    ),
  ),
),

                SizedBox(height: 20,),
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResultStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.name ?? 'Unknown'),
                              subtitle: Text(data.device.id.id),
                              trailing: Text(data.rssi.toString()),
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DeviceDetailPage(
        device: BluetoothDeviceModel(
          device: data.device,
          name: data.device.name ?? 'Unknown',
          id: data.device.id.id,
          rssi: data.rssi,
          isConnected: false, // You might initialize this based on your actual state
        ),
      ),
    ),
  );
},



                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("No device"));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
