import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/search_screen/widget/rating_star.dart';

class StadiumInfoSummary extends StatelessWidget {
  final int totalReservations;
  final String avgReviews;
  final int totalReviews;

  const StadiumInfoSummary({
    Key? key,
    required this.totalReservations,
    required this.avgReviews,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: Responsive.screenHeight(context) * 0.08,
        width: Responsive.screenWidth(context) * 1,
        decoration: BoxDecoration(
          border: Border.all(color: Constants.txtColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  totalReservations.toString(),
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "عدد الحجوزات",
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            VerticalDivider(
              width: Responsive.screenWidth(context) * 0.003,
              thickness: Responsive.screenWidth(context) * 0.003,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  avgReviews,
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                  ),
                ),
                StarRating(
                  rating: double.parse(avgReviews),
                  size: Responsive.screenHeight(context) * 0.02,
                ),
              ],
            ),
            VerticalDivider(
              width: Responsive.screenWidth(context) * 0.003,
              thickness: Responsive.screenWidth(context) * 0.003,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  totalReviews.toString(),
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                  ),
                ),
                Text(
                  "تقييمات الملعب",
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}