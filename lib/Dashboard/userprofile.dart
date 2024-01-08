import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapp/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobileapp/login and signup/loginpage.dart';
import 'package:mobileapp/Dashboard/Setting/UserAvatar.dart';
import 'package:mobileapp/Dashboard/Setting/DailyReportSwitch.dart';
import 'package:mobileapp/Dashboard/Setting/AlertsSwitch.dart';
import 'package:mobileapp/Dashboard/Setting/SwitchListItem.dart';
import 'package:mobileapp/Dashboard/Setting/firmware.dart';
import 'package:mobileapp/Dashboard/Setting/LogoutListItem.dart';
import 'package:mobileapp/Dashboard/Setting/scan_device.dart';
import 'package:mobileapp/Dashboard/Setting/Access_policoes.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

Future<String?> loadSessionData() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final email = sharedPreferences.getString('email');
  final password = sharedPreferences.getString('password');
  String? token = sharedPreferences.getString('token');
  Map<String, dynamic> decodedToken =
      token != null ? JwtDecoder.decode(token) : {};
  return decodedToken['email'];
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool dailyReportEnabled = true;
  bool alertsEnabled = true;
  bool smsEnabled = true;
  String? officialEmail;
  String? userEmail;
  @override
  void initState() {
    super.initState();
    loadSessionData();
  }

  Future<void> loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    String? token = sharedPreferences.getString('token');
    Map<String, dynamic> decodedToken =
        token != null ? JwtDecoder.decode(token) : {};
    String? officialEmail;
    print(decodedToken.containsKey('officialEmail'));
    if (decodedToken.containsKey('officialEmail')) {
      officialEmail = decodedToken['officialEmail'];

      setState(() {
        userEmail = officialEmail;
      });
    }
    print("Official Email: $officialEmail");
    print("email");
// if (decodedToken.containsKey('email')) {
//       setState(() {
//         userEmail = decodedToken['email'];
//         print("useremail,$userEmail");
//       });
    //   }
    print('Stored Email: $email');
    print('Stored Password: $password');
    print("token: $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(' Setting Page'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          UserAvatarCard(userEmail: userEmail),
          //  buildListItem("Email", ""),
          //Divider(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          //  Divider(),
          DailyReportSwitch(initialValue: dailyReportEnabled),
          //  Divider(),
          SizedBox(
            height: 5,
          ),
          AlertsSwitch(initialValue: alertsEnabled),
          //Divider(),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "SMS",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SmsSwitchListItem(
            //label: "SMS",
            switchValue: smsEnabled,
            onChanged: (newValue) {
              // Handle onChanged logic here
              setState(() {
                smsEnabled = newValue;
              });
            },
          ),
          // Divider(),
          SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "FIRMWARE",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FirmwareArrowListItem(
            //label: "Firmware",

            onTap: () {
              // Execute your navigation logic here, for example:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          //Divider(),

          //buildListItem("Firmware", "1.0.0"),
          //buildListItemWithArrow("Firmware", "firmware_Update", context),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "Device",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          // AddScanDevice( () {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => ScanDevicePage()),
          //   );
          // });AddScanDevice(
          AddScanDevice(
            onTap: () {
              // Your onTap logic here
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ScanDevicePage()),
              );
            },
          ),
          SizedBox(
            height: 80,
          ),

          Access_policies("Access Policy", "", context),

          SizedBox(
            height: 10,
          ),
          AboutUs("about us", "", context),
          SizedBox(
            height: 10,
          ),

          TermsandConditions("Terms and Conditions", "Read Our Terms", context),

          SizedBox(
            height: 10,
          ),
          // Text(
          //   "Logout",
          //   style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          //),
          LogoutListItem(value: "Log Out"),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buildListItem(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

Widget TermsandConditions(String title, String subtitle, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: 8),
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "Terms and conditions",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
            child: ListTile(
                // title: Text(title),
                // subtitle: Text(subtitle),
                // onTap: () {
                //   // Navigate to Access Policies Page and replace the current route
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => AccessPolicies()),
                //   );
                // },
                )),
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccessPolicies()),
            ),
          },
          child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),
        )
      ],
    ),
  );
}

Widget AboutUs(String title, String subtitle, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: 8),
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "About us",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
            child: ListTile(
                // title: Text(title),
                // subtitle: Text(subtitle),
                // onTap: () {
                //   // Navigate to Access Policies Page and replace the current route
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => AccessPolicies()),
                //   );
                // },
                )),
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccessPolicies()),
            ),
          },
          child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),
        )
      ],
    ),
  );
}

Widget AddScanDevice({String? value, required void Function() onTap}) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: 8),
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            value != null ? "Add Device: $value" : "Add Device",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: ListTile(
            onTap: onTap,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),
        ),
      ],
    ),
  );
}

// Example usage:

Widget Access_policies(String title, String subtitle, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(right: 8, left: 8),
    height: 40,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "Access_policies",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
            child: ListTile(
                // title: Text(title),
                // subtitle: Text(subtitle),
                // onTap: () {
                //   // Navigate to Access Policies Page and replace the current route
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => AccessPolicies()),
                //   );
                // },
                )),
        GestureDetector(
          onTap: () => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccessPolicies()),
            ),
          },
          child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),
        )
      ],
    ),
  );
}

void main() {
  runApp(MaterialApp(home: UserProfilePage()));
}
