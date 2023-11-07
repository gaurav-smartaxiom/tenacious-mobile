import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        children: [
          UserAvatarCard(userEmail: userEmail),
         //  buildListItem("Email", ""),
           //Divider(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          //  Divider(),
          DailyReportSwitch(initialValue: dailyReportEnabled),
         //  Divider(),
          AlertsSwitch(initialValue: alertsEnabled),
           Divider(),
          SmsSwitchListItem(
            label: "SMS",
            switchValue: smsEnabled,
            onChanged: (newValue) {
              // Handle onChanged logic here
              setState(() {
                smsEnabled = newValue;
              });
            },
          ),
          Divider(),
           FirmwareArrowListItem(
            label: "Firmware",
            subtitle: "firmware_Update",
            onTap: () {
              // Execute your navigation logic here, for example:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),   
           Divider(),      

          //buildListItem("Firmware", "1.0.0"),
          //buildListItemWithArrow("Firmware", "firmware_Update", context),
 buildListItem1("Add Device", "Add a New Device and scan",(){
 Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ScanDevicePage()),
  );

 }),

            Divider(),      

          

          buildListItem("Access Policy", "Manage Access Policy"),
            Divider(),      

          buildListItem("About Us", "Learn About Us"),
            Divider(),      

          buildListItem("Terms and Conditions", "Read Our Terms"),
            Divider(),      

          LogoutListItem(label: "Logout", value: "Log Out"),
Divider(),
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
Widget buildListItem1(String label, String value, void Function() onTap) {
  return ListTile(
    title: Text(label),
    subtitle: Text(value),
    onTap: onTap,
  );
}





void main() {
  runApp(MaterialApp(home: UserProfilePage()));
}



     
