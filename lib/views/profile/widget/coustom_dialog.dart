import 'package:flutter/material.dart';
import 'package:sport/utilits/responsive.dart';
import '../../auth/widgets/coustom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String canceText;
  final String? confirmText;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final double? height;
  final double? width;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.canceText,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.color,
    this.borderColor,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: height ?? Responsive.screenHeight(context) * 0.21,
        width: width ?? Responsive.screenWidth(context) * 0.8,
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
                if (confirmText != null)
                  CustomButton(
                    text: confirmText!,
                    onPress: onConfirm,
                    textSize: Responsive.textSize(context, 12.5),
                    color: color ?? Colors.red,
                    textColor: textColor ?? Colors.white,
                    borderColor: borderColor,
                    height: Responsive.screenHeight(context) * 0.05,
                    hasBorder: false,
                    width: confirmText != null ? Responsive.screenWidth(context) * 0.33 : Responsive.screenWidth(context) * 0.66,
                  ),
                CustomButton(
                  text: canceText,
                  onPress: onCancel,
                  textSize: Responsive.textSize(context, 12.5),
                  color: Colors.white,
                  textColor: textColor ?? Colors.black54,
                  borderColor: borderColor ?? Colors.black54,
                  hasBorder: true,
                  height: Responsive.screenHeight(context) * 0.05,
                  width: confirmText != null ? Responsive.screenWidth(context) * 0.33 : Responsive.screenWidth(context) * 0.66,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}