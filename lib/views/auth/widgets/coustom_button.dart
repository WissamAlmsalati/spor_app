import 'package:flutter/material.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../../utilits/responsive.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final bool hasBorder;
  final double? brWidth;
  final double height;
  final double width;
  final double? textSize;
  final FontWeight? fontWeight;
  final bool isLoading; // New parameter
  final Color? loadingColor;
  final double? loadingSize;

  const CustomButton({
    super.key,
    required this.onPress,
    required this.text,
    required this.color,
    this.borderColor,
    this.hasBorder = false,
    required this.textColor,
    required this.height,
    required this.width,
    this.textSize,
    this.fontWeight,
    this.brWidth,
    this.isLoading = false, // Default value
    this.loadingColor, this.loadingSize,
  }) : assert(hasBorder == false || borderColor != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
            side: hasBorder ? BorderSide(color: borderColor!, width: brWidth ?? 2) : BorderSide.none,
          ),
        ),
        child: isLoading
            ? LoadingAnimation(size: loadingSize!, color: loadingColor)
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: textSize ?? 20,
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              ),
      ),
    );
  }
}
