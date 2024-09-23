import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/controller/Reservation_fetch/reservation_fetch_state.dart';
import 'package:sport/views/Booking/widget/current_book_widget.dart';
import '../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../utilits/responsive.dart';

class CurrentBooking extends StatelessWidget {
  const CurrentBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          if (state is ReservationLoading) {
            return const ShimmerLoadingWidget();
          } else if (state is ReservationLoaded) {
            if (state.reservations.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد حجوزات حالية',
                  style: TextStyle(fontSize: Responsive.textSize(context, 12)),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReservationCubit>().fetchReservations();
              },
              child: ListView.builder(
                itemCount: state.reservations.length,
                itemBuilder: (context, index) {
                  return CurrentBookWidget(reservation: state.reservations[index]);
                },
              ),
            );
          } else if (state is ReservationError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  fontSize: Responsive.textSize(context, 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}





class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big Box with small boxes inside
            Container(
              height: Responsive.screenHeight(context) * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Box 1 (simulating text)
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.6,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    // Small Box 2 (simulating text)
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.4,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    // Small Box 3 (simulating button)
                    Container(
                      height: Responsive.screenHeight(context) * 0.05,
                      width: Responsive.screenWidth(context) * 0.3,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}