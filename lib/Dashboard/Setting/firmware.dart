import 'package:flutter/material.dart';
import 'package:mobileapp/HomePage.dart';

class FirmwareArrowListItem extends StatelessWidget {
  final VoidCallback onTap;

  FirmwareArrowListItem({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(right: 8,left: 8),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListTile(
              onTap: onTap,
            ),
          ),

          //SizedBox(width: 50,),
          Padding(
            padding: const EdgeInsets.only(right: 233),
            child: Text(
              "Update firmware",
              style: TextStyle(fontSize: 16),
            ),
          ),

GestureDetector(onTap: ()=>{

Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()))

},child: Icon(Icons.arrow_forward_ios, size: 27, color: Colors.white),)
          
        ],
      ),
    );
  }
}
