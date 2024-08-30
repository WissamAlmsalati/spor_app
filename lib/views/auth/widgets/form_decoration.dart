import 'package:flutter/material.dart';
import '../../../utilits/responsive.dart';

class FormDecoration extends StatelessWidget {
  final Widget child;
  final double height;
  const FormDecoration({super.key, required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Container(
        width: Responsive.screenWidth(context) * 0.810,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }
}
