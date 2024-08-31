import 'package:flutter/material.dart';
import '../../../utilits/responsive.dart';

class FormDecoration extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;
  const FormDecoration({super.key, required this.child, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Container(
        margin: EdgeInsets.zero,
        width:width?? Responsive.screenWidth(context) * 0.810,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.04),
        ),
        child: child,
      ),
    );
  }
}
