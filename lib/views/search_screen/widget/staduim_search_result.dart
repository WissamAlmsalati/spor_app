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
        height: Responsive.screenHeight(context) * 0.27,
        width: Responsive.screenWidth(context) * 9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(Responsive.screenWidth(context) * 0.05)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.16,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(Responsive.screenWidth(context) * 0.05),
                  topRight:
                      Radius.circular(Responsive.screenWidth(context) * 0.05),
                ),
                image: stadium.image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(stadium.image),
                        fit: BoxFit.fill,
                        onError: (error, stackTrace) {
                          // Handle error
                        },
                      )
                    : null,
              ),
              child: stadium.image.isEmpty
                  ? const Center(
                      child: Text(
                        'No image available',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.011,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.01,
                left: Responsive.screenWidth(context) * 0.05,
                right: Responsive.screenWidth(context) * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stadium.name.isNotEmpty == true ? stadium.name : 'ملعب',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,

                        ),
                      ),
                      SizedBox(
                        height: Responsive.screenHeight(context) * 0.01,
                      ),
                      Row(
                        children: [
                          Text(
                            '${stadium.address}.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Constants.txtColor,
                                  fontWeight: FontWeight.w900,

                                ),
                          ),
                          SvgPicture.asset(
                            AppPhotot.starLogo,
                            height: Responsive.screenHeight(context) * 0.014,
                            width: Responsive.screenWidth(context) * 0.014,
                          ),
                          Text(
                            stadium.avgRating.toString(),
                            style: TextStyle(
                                fontSize: Responsive.textSize(context, 12.5)),
                          ),
                          Text(
                            ' (${stadium.totalRating.toString()})',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Constants.txtColor,
                              fontWeight: FontWeight.w900,

                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    stadium.isFavorite ? 'متوفر للحجز' : 'غير متوفر للحجز',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: stadium.isFavorite
                              ? Constants.mainColor
                              : Colors.red,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
