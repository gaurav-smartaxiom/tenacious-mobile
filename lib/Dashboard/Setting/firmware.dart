import 'package:flutter/material.dart';

class FirmwareArrowListItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  FirmwareArrowListItem({
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
