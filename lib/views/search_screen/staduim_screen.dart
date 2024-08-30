import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/search_screen/widget/HorizontalCalendar.dart';
import 'package:sport/views/search_screen/widget/session_list.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import 'package:sport/views/stadium/screens/widget/comments_widget.dart';
import '../../app/app_packges.dart';
import '../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'package:shimmer/shimmer.dart';

class StadiumDetailScreen extends StatelessWidget {
  final int stadiumId;

  const StadiumDetailScreen({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StadiumDetailCubit>();
    cubit.fetchStadiumById(stadiumId);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StadiumDetailCubit, StaduimDetailState>(
          builder: (context, state) {
            if (state is StaduimDetailLoading) {
              return StadiumDetailShimmer(); // Use the new shimmer class
            } else if (state is StaduimDetailLoaded) {
              final stadium = state.stadiumInfo;
              final sessions = state.availableSessions;
              final selectedSession = sessions.firstWhere((session) => session.date == cubit.selectedDate);

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: StaduimPhotoStack(
                        StdPhoto: stadium.images[0], stdId: stadium.id),
                  ),
                ],
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stadium.name,
                                  style: TextStyle(
                                      fontSize: Responsive.textSize(context, 12),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.015,
                              ),
                              Text(stadium.address,
                                  style: TextStyle(
                                      fontSize: Responsive.textSize(context, 8))),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              StadiumInfoSummary(
                                totalReservations: stadium.totalReservations, // Replace with actual value
                                avgReviews: stadium.avgReviews, // Replace with actual value
                                totalReviews: stadium.totalReviews, // Replace with actual value
                              ),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              Text("اختيار اليوم",
                                  style: TextStyle(
                                      fontSize: Responsive.textSize(context, 10),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              DateSelector(
                                dates: sessions
                                    .map((session) => session.date)
                                    .toList(),
                                selectedDate: cubit.selectedDate,
                                onDateSelected: (date) {
                                  cubit.setSelectedDate(date);
                                },
                              ),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              Text("اختيار التوقيت",
                                  style: TextStyle(
                                      fontSize: Responsive.textSize(context, 10),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              SessionList(
                                availableSession: selectedSession,
                                selectedSessionId: cubit.selectedSessionId,
                                onTimeSelected: (sessionId) {
                                  cubit.setSelectedSessionId(sessionId);
                                },
                              ),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              Text("التعليقات",
                                  style: TextStyle(
                                      fontSize: Responsive.textSize(context, 10),
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: Responsive.screenHeight(context) * 0.02,
                              ),
                              Container(
                                  height: Responsive.screenHeight(context) * 0.47,
                                  child: CommentsWidget(stadiumId: stadium.id)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price: \$100', // Replace with actual price
                            style: TextStyle(
                              fontSize: Responsive.textSize(context, 10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BlocConsumer<ReverseRequestCubit, ReverseRequestState>(
                            listener: (context, state) {
                              if (state is ReverseRequestSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Request sent successfully')));
                              } else if (state is ReverseRequestError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              }
                            },
                            builder: (context, state) {
                              if (state is ReverseRequestLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  print('Send Reverse Request');
                                  print('Stadium ID: $stadiumId');
                                  print('Date: ${cubit.selectedDate}');
                                  print('Session ID: ${cubit.selectedSessionId}');
                                  print('Is Monthly Reservation: true');
                                  print('Payment Type: 2');
                                  context
                                      .read<ReverseRequestCubit>()
                                      .sendReverseRequest(
                                    stadiumId,
                                    cubit.selectedDate,
                                    cubit.selectedSessionId,
                                    true,
                                    2,
                                  );
                                },
                                child: const Text('Send Reverse Request'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is StaduimDetailError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}



class StadiumDetailShimmer extends StatelessWidget {
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
              height: Responsive.screenHeight(context) * 0.22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 8.0),

            // Stadium name placeholder
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.022),

            // Stadium address placeholder
            Container(
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.022),

            // Date selector placeholders
            Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: Responsive.screenWidth(context) * 0.2,
                  height: Responsive.screenHeight(context) * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.05),
                  ),
                );
              }),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Time selector placeholders
            Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: Responsive.screenWidth(context) * 0.2,
                  height: Responsive.screenHeight(context) * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.05),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
