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
              logo,
            ),
            SizedBox(
              width: Responsive.screenWidth(context) * 0.02,
            ),
            Text(
              title,
              style:  Theme.of(context).textTheme.headlineMedium?.copyWith(

                  color: Constants.mainColor,
                  fontWeight: FontWeight.w700,


              ),
            ),
            SizedBox(
              width: Responsive.screenWidth(context) * 0.02,
            ),
            SvgPicture.asset(
              logo,
            ),
          ],
        ),
        SizedBox(
          height: Responsive.screenHeight(context) * 0.002,
        ),
        Text(description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Constants.txtColor,
              fontWeight: FontWeight.w700,
            )
            ),

      ],
    );
  }
}
