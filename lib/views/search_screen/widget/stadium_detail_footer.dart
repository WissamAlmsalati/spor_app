import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';

import '../../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../../Booking/booking_screen.dart';
import 'stadium_detail_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import '../../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import 'stadium_detail_dialog.dart';

class StadiumDetailFooter extends StatelessWidget {
  final stadium;
  final StadiumDetailCubit cubit;

  const StadiumDetailFooter(
      {super.key, required this.stadium, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final bool isReverseCompleted = false;
    final bool noSessions = cubit.selectedSessionId == null;

    return Container(
      width: double.infinity,
      height: Responsive.screenHeight(context) * 0.1,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocConsumer<ReverseRequestCubit, ReverseRequestState>(
                    listener: (context, state) {
                      if (state is ReverseRequestSuccess) {
                        StadiumDetailDialog.showReservationStatusDialog(
                            context, 'تم الحجز بنجاح', 'تم حجز الملعب بنجاح');
                        context.read<ReservationCubit>().fetchReservations();
                      } else if (state is ReverseRequestError) {
                        StadiumDetailDialog.showReservationStatusDialog(
                            context, 'خطأ', state.message);
                      } else if (state is NoBalance) {
                        StadiumDetailDialog.showReservationStatusDialog(
                            context, 'خطأ', 'رصيدك غير كافي');
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<StadiumDetailCubit,
                          StaduimDetailState>(
                        builder: (BuildContext context,
                            StaduimDetailState state) {
                          return CustomButton(
                            textSize: Responsive.textSize(context, 14),
                            onPress: () {
                              if (cubit.selectedSessionId == null) {
                                Fluttertoast.showToast(
                                  msg: "يرجى اختيار توقيت الحجز",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                              state is StaduimDetailLoadedEmptySession
                                  ? null
                                  : showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.0)),
                                ),
                                builder: (context) =>
                                    AcceptReservationBottomSheet(
                                      stadiumName: stadium.name,
                                      date: cubit.selectedDate,
                                      time: cubit.selectedTime,
                                      price: "${stadium.sessionPrice} دينار",
                                      title: 'تأكيد الحجز',
                                      confirmText: 'تأكيد',
                                      cancelText: 'إلغاء',
                                      onConfirm: () {
                                        try {
                                          Navigator.of(context).pop();
                                          context.read<ReverseRequestCubit>()
                                              .sendReverseRequest(
                                            stadium.id,
                                            cubit.selectedDate,
                                            cubit.selectedSessionId!,
                                            false,
                                            1,
                                          );
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                              );
                            },
                            text: state is StaduimDetailLoadedEmptySession
                                ? 'غير متوفر'
                                : 'احجز الان',
                            color: state is StaduimDetailLoadedEmptySession
                                ? Colors.red
                                : Constants.mainColor,
                            textColor: Colors.white,
                            height: Responsive.screenHeight(context) * 0.06,
                            width: Responsive.screenWidth(context) * 0.4,
                            isDisabled: state is StaduimDetailLoadedEmptySession,
                          );
                        },
                      );
                    },
                  ),
                  Text(
                    "${stadium.sessionPrice} دينار",
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 22),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else {
              return CustomButton(
                  onPress: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  text: 'تسجيل الدخول',
                  color: Constants.mainColor,
                  textColor: Colors.white,
                  height: Responsive.screenHeight(context) * 0.06,
                  width: Responsive.screenWidth(context) * 0.4);
            }
          },
        ),
      ),
    );
  }
}


class AcceptReservationBottomSheet extends StatelessWidget {
  final String stadiumName;
  final String date;
  final String time;
  final String price;
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const AcceptReservationBottomSheet({
    super.key,
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.price,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.textSize(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          DottedRowDivider(height: Responsive.screenHeight(context) * 0.001),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),

          // Stadium Name
          _buildReservationDetailRow(
            context,
            'الملعب:',
            stadiumName,
          ),

          // Date
          _buildReservationDetailRow(
            context,
            'التاريخ:',
            date,
          ),

          // Time
          _buildReservationDetailRow(
            context,
            'الوقت:',
            time,
          ),

          // Price
          _buildReservationDetailRow(
            context,
            'السعر:',
            '$price دينار',
          ),

          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: confirmText,
                onPress: onConfirm,
                textSize: Responsive.textSize(context, 14),
                color: Constants.mainColor,
                textColor: Colors.white,
                height: Responsive.screenHeight(context) * 0.05,
                width: Responsive.screenWidth(context) * 0.33,
              ),
              CustomButton(
                text: cancelText,
                onPress: onCancel,
                textSize: Responsive.textSize(context, 14),
                color: Colors.white,
                textColor: Colors.black54,
                height: Responsive.screenHeight(context) * 0.05,
                width: Responsive.screenWidth(context) * 0.33,
              ),
            ],
          ),

          // Add the dotted border below the buttons

        ],
      ),
    );
  }

  Widget _buildReservationDetailRow(BuildContext context, String label,
      String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.textSize(context, 14),
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.textSize(context, 14),
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


class DottedRowDivider extends StatelessWidget {
  final double height;
  final Color color;

  const DottedRowDivider({
    Key? key,
    this.height = 1.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _DottedRowDividerPainter(color: color, height: height),
    );
  }
}

class _DottedRowDividerPainter extends CustomPainter {
  final double height;
  final Color color;

  _DottedRowDividerPainter({required this.color, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 6.0;
    double dashSpace = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = height;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}