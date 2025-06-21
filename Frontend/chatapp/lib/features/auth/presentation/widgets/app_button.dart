import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AppButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.06,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepPurple],
          ),
          borderRadius: borderRadius,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent, // remove elevation shadow
            padding: EdgeInsets.zero, // match container
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        ),
      ),
    );
  }
}
