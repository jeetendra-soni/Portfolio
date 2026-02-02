import 'package:flutter/material.dart';

import '../animated_container.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  final bool secondary;
  final Widget? icon;

  const CustomButton({super.key, required this.onTap, required this.title, this.icon, this.secondary = false});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SizedBox(
        height: widget.secondary ? 40 : 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: widget.secondary ? 16 : 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: widget.icon ?? const SizedBox(),
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
