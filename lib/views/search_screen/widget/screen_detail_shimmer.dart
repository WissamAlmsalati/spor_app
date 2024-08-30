

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/app_packges.dart';

class StadiumDetailShimmerLoading extends StatelessWidget {
  const StadiumDetailShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stadium image placeholder
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Stadium name placeholder
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Stadium address placeholder
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),
            // Date selector placeholders
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: Responsive.screenWidth(context) * 0.2,
                    height: Responsive.screenHeight(context) * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          Responsive.screenWidth(context) * 0.05),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),
            // Date selector placeholders4
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: Responsive.screenWidth(context) * 0.2,
                    height: Responsive.screenHeight(context) * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          Responsive.screenWidth(context) * 0.05),
                    ),
                  );
                }),
              ),


            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),
            // Date selector placeholders4
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.1,
              color: Colors.white,

            ),
          ],
        ),
      ),
    );
  }
}
