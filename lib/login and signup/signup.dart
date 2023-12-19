import 'package:flutter/material.dart';
//import 'package:bbbb/Dashboard/Dashboard.dart';
import 'package:mobileapp/Dashboard/Dashboard.dart';
import 'loginpage.dart';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ConfrompasswordController = TextEditingController();
  TextEditingController _OrgnazationController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfrompasswordVisible = false;
  bool _isChecked = false;

// Future  Loginuser() async{
//    final String apiUrl='http://localhost:3001/data/login/';
// final response= await http.post(Uri.parse(apiUrl),

// body: {

// 'username':_usernameController.text ,
// 'password':_passwordController.text ,
// }    

// );
//   //print('Response status code: ${response.statusCode}');
//     print('Response body: ${response.body}');

// if(response.statusCode==200)
// {
// print("user login sucessfully");
//  Navigator.pushReplacementNamed(context, '/signup');
// }
// else
// {
//   print("login faild");
// }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 2000,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.0), 
                  child: Image.asset(
                    'assets/download.png',
                    width: 800,
                    height: 150,
                  ),
                ),
                SizedBox(height: 80),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _EmailController,
                        decoration: InputDecoration(
                          labelText: "EmailID",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                //  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //keyboardType: TextInputType.number,
                  controller: _ConfrompasswordController,
                  obscureText: !_isConfrompasswordVisible,
                  decoration: InputDecoration(
                    labelText: "ConfromPassword",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //keyboardType: TextInputType.number,
                  controller: _OrgnazationController,
                  decoration: InputDecoration(
                    labelText: "Orgnazation",
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                            });
                        },
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'By creating this account you agree to ',
                                style: TextStyle(
                                  color:
                                      Colors.black, 
                                ),
                              ),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(
                                  color: Colors.blue, 
                                  decoration: TextDecoration
                                      .underline, 
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: ElevatedButton(
                        onPressed: () {
                          print("hello");
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                        },
                        style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                        child: Text('Sign up'), 
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3),
        // color: Colors.yellow,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // Navigate to the login page here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text.rich(
                TextSpan(
                  text: "I have already account",
                  children: [
                    TextSpan(
                      text: ' Sign in',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
    
  }
}
