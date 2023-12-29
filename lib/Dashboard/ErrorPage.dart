import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/Error.png",
                width: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "ERROR",
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "SOMETHING WENT WRONG PLEASE TRY AGAIN !",
                  style: TextStyle(fontSize: 16),
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
print("Try Again")
      },child:Container(
      
      width: 300,
      height: 60,  // Added height
      color: Colors.red,
      child: Center(
        child: Text(
          "TRY AGAIN",
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
