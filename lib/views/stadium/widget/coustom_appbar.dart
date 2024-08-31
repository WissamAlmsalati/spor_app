import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utilits/responsive.dart';
import 'package:shimmer/shimmer.dart';

class CoustomAppBr extends StatelessWidget {
  final String logo;
  final String title;
  final Color? color;
  final double? height;
  final double? width;
  final VoidCallback? onPressed;
  final Widget? child;
  final bool isLoading;
  final Widget? loadingWidget;

  const CoustomAppBr({
    super.key,
    required this.logo,
    required this.title,
    this.color,
    this.height,
    this.width,
    this.onPressed,
    this.child,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: Responsive.screenWidth(context) * 0.4,
                  height: Responsive.screenHeight(context) * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                    fontSize: Responsive.textSize(context, 20), color: color),
              ),
        loadingWidget ??
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: SizedBox(
            height: height,
            width: width,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.025),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                    Responsive.screenWidth(context) * 0.03),
                child: SvgPicture.asset(
                  logo,
                ),
              ) ?? child,
            ),
          ),
        ),
      ],
    );
  }
}