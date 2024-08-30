import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}