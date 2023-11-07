import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final bool isUsernameVisible;
  final TextEditingController usernameController;
  final VoidCallback toggleUsernameVisibility;

  UsernameField({
    required this.isUsernameVisible,
    required this.usernameController,
    required this.toggleUsernameVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleUsernameVisibility,
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Colors.blue,
          ),
          SizedBox(width: 8),
          Text(
            "OfficalUserEmail",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          Icon(
            isUsernameVisible
                ? Icons.arrow_drop_up_sharp
                : Icons.arrow_drop_down,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
