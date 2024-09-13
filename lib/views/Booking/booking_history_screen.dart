import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/old_reveresition/old_reservation_fetch_cubit.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/Booking/widget/history_booking_widget.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OldReservationFetchCubit, OldReservationFetchState>(
        builder: (context, state) {
          if (state is OldReservationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OldReservationLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<OldReservationFetchCubit>()
                    .fetchOldReservations();
              },
              child: ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  return HistoryBookingWidget(
                      reservation: state.reservations[index]);
                },
              ),
            );
          } else if (state is OldReservationEmpty) {
            return Center(child: Text(state.message,style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.textSize(context, 12),
            ),));
          } else if (state is UnAuthenticated) {
            return Center(
                child: Text(
              'انشئ حساب و احجز ملاعبك المفضلة',
              style: TextStyle(
                fontSize: Responsive.textSize(context, 12),
                fontWeight: FontWeight.w600,
              ),
            ));
          } else if (state is OldReservationSocketExceptionError) {
            return Center(
                child: Text(
              'لا يوجد اتصال بالانترنت',
              style: TextStyle(
                fontSize: Responsive.textSize(context, 2.5),
              ),
            ));
          } else if (state is OldReservationError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
