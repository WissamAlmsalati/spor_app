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
    // Assuming 100 blocks across the height
    return screenHeight(context) / 100;
  }

  // Example usage for text scaling
  static double textSize(BuildContext context, double size) {

    double screenWidth = MediaQuery.of(context).size.width;
    return size * screenWidth / 375; // Assuming 375 is the base width.
  }

  // Add more methods as needed for padding, margin, etc.
}