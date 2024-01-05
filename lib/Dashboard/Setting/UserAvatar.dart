import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/Dashboard/Setting/userdeatils.dart';

class UserAvatarCard extends StatefulWidget {
  final String? userEmail;
  UserAvatarCard({this.userEmail});

  @override
  _UserAvatarCardState createState() => _UserAvatarCardState();
}

class _UserAvatarCardState extends State<UserAvatarCard> {
  File? _userImage; // Store the selected user image

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImage');

    if (imagePath != null) {
      setState(() {
        _userImage = File(imagePath);
      });
    }
  }

  Future<void> _pickUserImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userImage', imageFile.path);

      setState(() {
        _userImage = imageFile;
      });
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickUserImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8,top: 5,left: 8),
      //width: ,
      height: 75,

      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(1)),
      child: InkWell(
        onTap: () {
          _showImagePickerDialog();
        },
        child: ListTile(
          // contentPadding: EdgeInsets.all(10),
          // shape: RoundedRectangleBorder(
          //   side: BorderSide(
          //     color: Colors.white,
          //     width: 1.0,
          //   ),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          leading: CircleAvatar(
            backgroundImage: _userImage != null ? FileImage(_userImage!) : null,
            radius: 35,
          ),

          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(
                      //  userEmail: widget.userEmail,
                      //  userImage: _userImage,
                      //   subtitle: "Admin", // Pass the user's profile picture here
                      ),
                ),
              );
            },
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.userEmail ?? 'User Email'),

                // Padding(padding: const EdgeInsets.only(left: 67,top: 20),

                // child: Icon(Icons.arrow_forward_ios),

                // )

                // Padding(
                //   padding: const EdgeInsets.only(top: 10, left: 40),
                //   child: GestureDetector(
                //       onTap: () => {
                //             Navigator.of(context).push(
                //               MaterialPageRoute(
                //                 builder: (context) => UserDetailsPage(
                //                     //  userEmail: widget.userEmail,
                //                     //  userImage: _userImage,
                //                     //   subtitle: "Admin", // Pass the user's profile picture here
                //                     ),
                //               ),
                //             )
                //           },
                //       child: Icon(
                //         Icons.arrow_forward_ios,
                //         color: Colors.white,
                //         size: 35,
                //       )),
                // )
              ],
            ),
          ),
          subtitle: Text("Admin"),
        ),
      ),
    );
  }
}

// class UserDetailsPage extends StatelessWidget {
//   final String? userEmail;

//   UserDetailsPage({this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('User Email: ${userEmail ?? 'N/A'}'),
//             // Add more user details here
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: UserAvatarCard(userEmail: 'test@example.com')));
// }
