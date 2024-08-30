import 'package:flutter/material.dart';
import 'package:sport/utilits/responsive.dart';

import '../../auth/widgets/coustom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  final String canceText;
  final String confirmText;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content, required this.canceText, required this.confirmText, this.onConfirm, this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: Responsive.screenHeight(context) * 0.21,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.textSize(context, 12),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(content, style: TextStyle(fontSize: Responsive.textSize(context, 12))),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: confirmText,
                  onPress: onConfirm,
                  textSize: Responsive.textSize(context, 12.5),
                  color: Colors.red,
                  textColor: Colors.white,
                  height: Responsive.screenHeight(context) * 0.05,
                  hasBorder: false,
                  width: Responsive.screenWidth(context) * 0.33,
                ),
                CustomButton(
                  text: canceText,
                  onPress: onCancel,
                  textSize: Responsive.textSize(context, 12.5),
                  color: Colors.white,
                  hasBorder: true,
                  borderColor: Colors.black54,
                  textColor: Colors.black54,
                  height: Responsive.screenHeight(context) * 0.05,
                  width: Responsive.screenWidth(context) * 0.33,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
