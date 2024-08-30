import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';

class TitleLogoTitle extends StatelessWidget {
  final String logo;

  final String title;
  final String description;

  const TitleLogoTitle({
    super.key,
    required this.logo,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
             logo ,

            ),
            SizedBox(
              width: Responsive.screenWidth(context) * 0.02,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: Responsive.textSize(context, 14),
                  color: Constants.mainColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: Responsive.screenWidth(context) * 0.02,
            ),
            SvgPicture.asset(
              logo,

            ),
          ],
        ),
        Text(description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Responsive.textSize(context, 10),
              color: Constants.thirdColor.withOpacity(0.6),
            )),
      ],
    );
  }
}