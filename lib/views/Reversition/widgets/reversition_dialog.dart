import 'package:flutter/material.dart';

import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../../auth/widgets/coustom_button.dart';

class ReversitionDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const ReversitionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: Responsive.screenHeight(context) * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.textSize(context, 14),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              content,
              style: TextStyle(
                fontSize: Responsive.textSize(context,13),
                color: Constants.txtColor,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "موافق",
                  onPress: () {
                    Navigator.pop(context);
                  },
                  textSize: Responsive.textSize(context, 12),
                  color: color,
                  textColor: Colors.white,
                  height: Responsive.screenHeight(context) * 0.055,
                  hasBorder: false,
                  width: Responsive.screenWidth(context) * 0.72,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
