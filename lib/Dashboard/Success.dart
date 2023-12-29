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
                width: 150,
              ),
              SizedBox(
                height: 25,
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
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "USER HAS BEEN CREATED SUCCESSFULLY !",
                  style: TextStyle(fontSize: 18),
                ),
              ]),
              SizedBox(
                height: 150,
              ),
              Row(
   mainAxisAlignment: MainAxisAlignment.center,
  children: [
    InkWell(
      onTap:()=>{
print("continue")
      },child:Container(
      
      width: 300,
      height: 60,  // Added height
      color: Colors.green,
      child: Center(
        child: Text(
          "CONTINUE",
          style: TextStyle(color: Colors.white,fontSize: 25),
        ),
      ),
    ),),
   
  ],
),

            ]),
      ),
    );
  }
}