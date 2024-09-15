// lib/views/search_screen/widget/stadium_detail_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../../controller/check_box_monthe_price/check_box.dart';
import '../../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../../utilits/responsive.dart';
import '../../profile/widget/coustom_dialog.dart';

class StadiumDetailDialog {
  static void showReservationDialog(BuildContext context, stadium, String selectedDate, String selectedTime, bool isReserved, int selectedSessionId) {
    final isMonthlyReservation = context.read<CheckboxCubit>().state;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'تأكيد الحجز',
          content: 'اسم الملعب: ${stadium.name}\nعنوان الملعب: ${stadium.address}\nالتاريخ: $selectedDate\nالتوقيت: $selectedTime',
          canceText: 'إغلاق',
          confirmText: 'تأكيد',
          onConfirm: () {
            try {
              context.read<ReverseRequestCubit>().sendReverseRequest(
                stadium.id,
                selectedDate,
                int.parse(selectedTime), // Convert selectedTime to int
                isMonthlyReservation,
                selectedSessionId, // Pass the selectedSessionId
              );
              isReserved = true;
            } catch (e) {
              print(e);
            }
            context.read<ReservationCubit>().fetchReservations();
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          height: Responsive.screenHeight(context) * 0.3,
          width: Responsive.screenWidth(context) * 0.8,
        );
      },
    );
  }

  static void showReservationStatusDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: message,
          canceText: 'إغلاق',
          onCancel: () {
            Navigator.of(context).pop();
          },
          height: Responsive.screenHeight(context) * 0.2,
          width: Responsive.screenWidth(context) * 0.75,
        );
      },
    );
  }
}