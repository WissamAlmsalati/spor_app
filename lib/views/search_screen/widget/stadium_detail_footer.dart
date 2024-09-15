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
                            context, 'خطأ', 'حدث خطأ');
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<StadiumDetailCubit,
                          StaduimDetailState>(
                        builder:
                            (BuildContext context, StaduimDetailState state) {
                          return CustomButton(
                            textSize: Responsive.textSize(context, 14),
                            onPress: () {
                              state is StaduimDetailLoadedEmptySession
                                  ? null
                                  : StadiumDetailDialog.showReservationDialog(
                                      context,
                                      stadium,
                                      cubit.selectedDate,
                                      cubit.selectedTime,
                                      isReverseCompleted);
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
                            isDisabled:
                                state is StaduimDetailLoadedEmptySession,
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
