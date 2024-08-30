


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/stedum_model.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/images.dart';
import '../../../utilits/responsive.dart';

class StaduimSearchResult extends StatelessWidget {
  final Stadium stadium;
  const StaduimSearchResult({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: Responsive.screenHeight(context) * 0.25,
        width: Responsive.screenWidth(context) * 9,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Column(

          children: [
            Image.network(
              stadium.image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.16,
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.011,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.screenWidth(context)*0.05,
                right: Responsive.screenWidth(context)*0.05,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stadium.name.isNotEmpty == true ? stadium.name : 'ملعب',style: TextStyle(
                          fontSize: Responsive.textSize(context, 13)
                      ),),
                      Row(
                        children: [
                          Text('${stadium.address}.',style: TextStyle(
                              color: Constants.txtColor,
                            fontSize: Responsive.textSize(context, 12)
                          ),),

                          SvgPicture.asset(AppPhotot.starLogo,
                            height: Responsive.screenHeight(context)*0.014,
                            width: Responsive.screenWidth(context)*0.014,
                          ),
                          Text(stadium.avgRating.toString(),style: TextStyle(
                              fontSize: Responsive.textSize(context, 12.5)
                          ),),
                          Text(' (${stadium.totalRating.toString() })', style: TextStyle(
                              color: Constants.txtColor,
                            fontSize: Responsive.textSize(context, 12.2)
                          ),),
                        ],
                      )
                    ],
                  ),
                  Text(
                    stadium.isAvailable ? 'متوفر للحجز' : 'غير متوفر للحجز',
                    style: TextStyle(
                      color: stadium.isAvailable ? Constants.mainColor : Colors.red,
                      fontSize: Responsive.textSize(context, 13), // Customize the font size as needed
                    ),
                  ),                                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
