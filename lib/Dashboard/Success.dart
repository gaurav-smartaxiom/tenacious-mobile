import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/success.png",
                width: 200,
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "SUCCESS",
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "USER HAS BEEN CREATED SUCCESSFULLY !",
                  style: TextStyle(fontSize: 18),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 240,
                    decoration: BoxDecoration(),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
