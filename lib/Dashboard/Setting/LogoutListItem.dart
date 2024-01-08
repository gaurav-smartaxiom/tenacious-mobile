import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/login and signup/loginpage.dart';

class LogoutListItem extends StatelessWidget {
  final String value;

  LogoutListItem({
    this.value = '',
  });

  Future<void> performLogout(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? email = sharedPreferences.getString('email');
    final String? token = sharedPreferences.getString('token');

    if (email != null && token != null) {
      print("Logout");

      // Clear session data
      sharedPreferences.remove('email');
      sharedPreferences.remove('password');
      sharedPreferences.remove('token');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully'),
        ),
      );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),

      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            "Logout",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
            child: ListTile(
                // subtitle: Text(value),
                // onTap: () {
                //   performLogout(context);
                // },
                )),
        GestureDetector(
          onTap: () => {performLogout(context)},
          child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),
        )
      ]),

      //title: Text(label),
    );
  }
}
