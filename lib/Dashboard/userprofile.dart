import 'package:flutter/material.dart';
import 'package:mobileapp/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

Future<String?> loadSessionData() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final email = sharedPreferences.getString('email');
  final password = sharedPreferences.getString('password');
  String? token = sharedPreferences.getString('token');
  Map<String, dynamic> decodedToken = token != null ? JwtDecoder.decode(token) : {};
  return decodedToken['email'];
}



class _UserProfilePageState extends State<UserProfilePage> {
  bool dailyReportEnabled = true;
  bool alertsEnabled = true;
  bool smsEnabled = true;
   String? officialEmail;
   String?  userEmail   ;
   bool isHovered = false;

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
Map<String, dynamic> decodedToken = token != null ? JwtDecoder.decode(token) : {};
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
          buildUserAvatar(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text(
                  "Email",
                  style: TextStyle(fontSize: 18, ),
                ),
              ),
            ],
          ),
          buildGrayDailyReport(),
          buildGrayAlerts(),
          // Row(
          //   children: [
          //     Expanded(
          //       child: buildGrayDailyReport(),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 1),
          // // Row(
          // //   children: [
          // //     Expanded(
          // //       child: buildGrayAlerts(),
          // //     ),
          // //   ],
          // // ),
          buildListItemWithSwitch("SMS", smsEnabled, (newValue) {
            setState(() {
              smsEnabled = newValue;
            });
          }),
          //buildListItem("Firmware", "1.0.0"),
          buildListItemWithArrow("Firmware", "firmware_Update", context),
          buildListItem("Add Device", "Add a New Device"),
          buildListItem("Access Policy", "Manage Access Policy"),
          buildListItem("About Us", "Learn About Us"),
          buildListItem("Terms and Conditions", "Read Our Terms"),
          buildListItem("Logout", "Log Out"),
        ],
      ),
    );
  }

  Widget buildUserAvatar() {
  return Card(
    child: ListTile(
      contentPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/User_icon.png'),
        radius: 35,
        // child: Text(
        //  userEmail ?? 'User Email', // Display user email or a default value
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        // ),
      ),
      title: Text(userEmail ?? 'User Email'),
      subtitle: Text("Admin"),
    ),
  );
}


  Widget buildGrayDailyReport() {
    return ListTile(
      title: Text("Enable Daily Report"),
      tileColor: Colors.grey,
      trailing: Switch(
        value: dailyReportEnabled,
        onChanged: (newValue) {
          setState(() {
            dailyReportEnabled = newValue;
          });
        },
      ),
    );
  }

  Widget buildGrayAlerts() {
    return ListTile(
      title: Text("Enable Alerts"),
     // tileColor: Colors.grey,
      trailing: Switch(
        value: alertsEnabled,
        onChanged: (newValue) {
          setState(() {
            alertsEnabled = newValue;
          });
        },
      ),
    );
  }

  Widget buildListItem(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget buildListItemWithSwitch(String label, bool switchValue, Function(bool) onChanged) {
    return ListTile(
      title: Text("SMS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      subtitle: Text('Enable',style:  TextStyle(fontSize: 15),),
      trailing: Switch(
        value: switchValue,
        onChanged: onChanged,
      ),
    );
  }
}

//  Widget buildListItemWithArrow(String label, Function onTap, BuildContext context) {
//   return ListTile(
//     title: Text('Firmware'),
//     subtitle: Text('firmware_UpDate'),
//     trailing: Icon(Icons.arrow_forward), // You can customize the icon
//     onTap: () {
//       print('dddddddddddddd');
//       // Execute your navigation logic here
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//     },
//   );
// }


Widget buildListItemWithArrow(String label, String subtitle, BuildContext context) {
  return ListTile(
    title: Text(label),
    subtitle: Text(subtitle),
    onTap: () {
      print('$label item tapped');
      // Execute your navigation logic here
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    },
  );
}




void main() {
  runApp(MaterialApp(home: UserProfilePage()));
}
