import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utilits/responsive.dart';

class LogoText extends StatelessWidget {
  final String logo;
  final String text;
  const LogoText({super.key ,required this.logo,required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Responsive.blockHeight(context) * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            logo,
            width: Responsive.screenWidth(context) * 0.009,
            height: Responsive.screenHeight(context) * 0.02,
          ),
          SizedBox(width: Responsive.screenWidth(context) * 0.02
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.textSize(context, 15),
            ),
          )
        ],
      ),
    );
  }
}
