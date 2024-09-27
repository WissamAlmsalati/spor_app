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

class StadiumDetailFooter extends StatelessWidget {
  final stadium;
  final StadiumDetailCubit cubit;

  const StadiumDetailFooter({
    super.key,
    required this.stadium,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Responsive.screenHeight(context) * 0.1,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<StadiumDetailCubit, StaduimDetailState>(
                    builder: (BuildContext context, StaduimDetailState state) {
                      return CustomButton(
                        textSize: Responsive.textSize(context, 14),
                        onPress: () async {
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
                          if (state is! StaduimDetailLoadedEmptySession) {
                            final result = await showModalBottomSheet<bool>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              builder: (context) => AcceptReservationBottomSheet(
                                stadiumName: stadium.name,
                                date: cubit.selectedDate,
                                time: cubit.selectedTime,
                                price: "${stadium.sessionPrice} دينار",
                                title: 'تأكيد الحجز',
                                confirmText: 'تأكيد',
                                cancelText: 'إلغاء',
                                onConfirm: () {
                                  print ('stadium.id: ${stadium.id}+cubit.selectedDate: ${cubit.selectedDate}+cubit.selectedSessionId: ${cubit.selectedSessionId}');

                                  Navigator.of(context).pop(true);

                                },
                                onCancel: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            );

                            if (result == true) {
                              print ('stadium.id: ${stadium.id}+cubit.selectedDate: ${cubit.selectedDate}+cubit.selectedSessionId: ${cubit.selectedSessionId}');
                              try {
                                await context.read<ReverseRequestCubit>().sendReverseRequest(
                                  stadium.id,
                                  cubit.selectedDate,
                                  cubit.selectedSessionId!,
                                  false,
                                  1,
                                  context,
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "Error: $e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            }
                          }
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
                width: Responsive.screenWidth(context) * 0.4,
              );
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
          const BoxShadow(
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

          _buildReservationDetailRow(
            context,
            'الملعب:',
            stadiumName,
          ),

          _buildReservationDetailRow(
            context,
            'التاريخ:',
            date,
          ),

          _buildReservationDetailRow(
            context,
            'الوقت:',
            time,
          ),

          _buildReservationDetailRow(
            context,
            'السعر:',
            '$price ',
          ),

          SizedBox(
            height: Responsive.screenHeight(context) * 0.03,
          ),
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
          SizedBox(
            height: Responsive.screenHeight(context) * 0.03,
          )
        ],
      ),
    );
  }

  Widget _buildReservationDetailRow(
      BuildContext context, String label, String value) {
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
