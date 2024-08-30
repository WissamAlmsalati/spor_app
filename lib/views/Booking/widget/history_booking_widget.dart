
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../models/reservation.dart';
import '../../auth/widgets/coustom_button.dart';

import 'package:flutter_svg/svg.dart';

class HistoryBookingWidget extends StatelessWidget {
  final Reservation reservation;
  const HistoryBookingWidget({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {

    final endTime = DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(reservation.endTime));
    final startTime = DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(reservation.startTime));
    initializeDateFormatting('ar', null);

    DateTime date = DateTime.parse(reservation.date);
    String formattedDate = DateFormat('EEEE', 'ar').format(date);


    return Container(
      margin: EdgeInsets.all(Responsive.screenWidth(context) * 0.03),
      height: Responsive.screenHeight(context) * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding:  EdgeInsets.only(
          top: Responsive.screenHeight(context) * 0.02,
          left: Responsive.screenWidth(context) * 0.05,
          right: Responsive.screenWidth(context) * 0.05,
          bottom: Responsive.screenHeight(context) * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reservation.stadiumName, style: TextStyle(fontSize: Responsive.textSize(context, 10),
                fontWeight: FontWeight.w700),),
            Padding(
              padding:  EdgeInsets.only(top: Responsive.screenHeight(context) * 0.013),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppPhotot.locationIco,
                    color: Colors.green,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Responsive.screenWidth(context) * 0.02,),
                  Text(reservation.stadiumAddress, style: TextStyle(fontSize: Responsive.textSize(context, 8),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("يوم الحجز: ", style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                  Text(formattedDate, style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                  Container(
                    height: Responsive.screenHeight(context) * 0.005,
                    width: Responsive.screenWidth(context) * 0.04,
                    decoration: BoxDecoration(
                      color: Constants.txtColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(date.day.toString(), style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.53,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ساعة الحجز: ", style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                  Text(startTime, style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                  Container(
                    height: Responsive.screenHeight(context) * 0.005,
                    width: Responsive.screenWidth(context) * 0.04,
                    decoration: BoxDecoration(
                      color: Constants.txtColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(endTime, style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("حالة الحجز : ", style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                  Text("منتهي", style: TextStyle(fontSize: Responsive.textSize(context, 10),fontWeight: FontWeight.w500,color: Constants.txtColor),),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.056,
              width: double.infinity,
              child: CustomButton(
                onPress: (){

                },
                text:'اعادة الحجز',
                color: Constants.mainColor,
                textColor: Colors.white,
                height: Responsive.screenHeight(context) * 0.05,
                width: Responsive.screenWidth(context) * 0.3,
                textSize: Responsive.textSize(context, 10),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
