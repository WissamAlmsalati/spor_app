import 'dart:math';
import 'package:flutter/widgets.dart';

class Responsive {
  Responsive(BuildContext context);

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double blockHeight(BuildContext context) {
    return screenHeight(context) / 100;
  }

  static double textSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 390) * size;
    return max(12, val); // Ensure the text size is at least 12
  }
}