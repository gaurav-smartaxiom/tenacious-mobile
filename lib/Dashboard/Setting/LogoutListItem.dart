import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/login and signup/loginpage.dart';

class LogoutListItem extends StatelessWidget {
  final String label;
  final String value;

   LogoutListItem({
    required this.label,
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

    
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      onTap: () {
        performLogout(context); 
      },
    );
  }
}
