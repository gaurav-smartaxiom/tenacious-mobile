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
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      // Save the selected image path to SharedPreferences
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
              // Add more options for changing the profile picture, e.g., from camera, etc.
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _showImagePickerDialog();
        },
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
            backgroundImage: _userImage != null
                ? FileImage(_userImage!)
                : null,
            radius: 35,
          ),
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => UserDetailsPage(
     //userEmail: widget.userEmail,
     // userImage: _userImage,
      //subtitle: "Admin", // Pass the user's profile picture here
    ),
  ),
);

            },
            child: Text(widget.userEmail ?? 'User Email'),
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
