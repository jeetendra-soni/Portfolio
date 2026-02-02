import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  final String item;
  VoidCallback? onTap;
  NavbarItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        child: Text(
          item,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }
}
