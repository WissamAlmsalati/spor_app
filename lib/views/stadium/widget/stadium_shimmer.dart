import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utilits/responsive.dart';

class StadiumShimmer extends StatelessWidget {
  const StadiumShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.02,
              width: Responsive.screenWidth(context) * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.02,
              width: Responsive.screenWidth(context) * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.08,
              width: Responsive.screenWidth(context) * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.02,
              width: Responsive.screenWidth(context) * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.02,
              width: Responsive.screenWidth(context) * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: Responsive.screenHeight(context) * 0.02,
              width: Responsive.screenWidth(context) * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}