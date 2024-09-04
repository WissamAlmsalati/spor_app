import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import 'package:sport/views/search_screen/widget/HorizontalCalendar.dart';
import 'package:sport/views/search_screen/widget/screen_detail_shimmer.dart';
import 'package:sport/views/search_screen/widget/session_list.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import 'package:sport/views/stadium/screens/widget/comments_widget.dart';
import '../../app/app_packges.dart';
import '../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../profile/widget/coustom_dialog.dart';

class StadiumDetailScreen extends StatelessWidget {
  final int stadiumId;

  const StadiumDetailScreen({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StadiumDetailCubit>();
    cubit.fetchStadiumById(stadiumId);

    return Scaffold(
      backgroundColor: Constants.backGroundColor,
      body: SafeArea(
        child: BlocBuilder<StadiumDetailCubit, StaduimDetailState>(
          builder: (context, state) {
            if (state is StaduimDetailLoading) {
              return const StadiumDetailShimmerLoading();
            } else if (state is StaduimDetailLoaded) {
              final stadium = state.stadiumInfo;
              final sessions = state.availableSessions;
              final selectedSession = sessions.isNotEmpty
                  ? sessions.firstWhere(
                      (session) => session.date == cubit.selectedDate,
                      orElse: () => sessions.first,
                    )
                  : null;

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: stadium.images.isNotEmpty && stadium.images[0].isNotEmpty
                        ? StaduimPhotoStack(StdPhoto: stadium.images[0], stdId: stadiumId)
                        : Container(
                            height: Responsive.screenHeight(context) * 0.25,
                            color: Colors.grey,
                            child: const Center(child: Text('No image available', style: TextStyle(color: Colors.white))),
                          ),
                  ),
                ],
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stadium.name, style: TextStyle(fontSize: Responsive.textSize(context, 18), fontWeight: FontWeight.bold)),
                              SizedBox(height: Responsive.screenHeight(context) * 0.015),
                              Row(
                                children: [
                                  SvgPicture.asset(AppPhotot.locationIco),
                                  SizedBox(width: Responsive.screenWidth(context) * 0.02),
                                  Text(stadium.address, style: TextStyle(fontSize: Responsive.textSize(context, 14))),
                                ],
                              ),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              StadiumInfoSummary(
                                totalReservations: stadium.totalReservations,
                                avgReviews: stadium.avgReviews,
                                totalReviews: stadium.totalReviews,
                              ),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("اختيار اليوم", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                                  BlocBuilder<CheckboxCubit, bool>(
                                    builder: (context, isChecked) {
                                      return Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Constants.mainColor,
                                        value: isChecked,
                                        onChanged: (value) {
                                          context.read<CheckboxCubit>().toggle();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              sessions.isNotEmpty
                                  ? DateSelector(
                                      dates: sessions.map((session) => session.date).toList(),
                                      selectedDate: cubit.selectedDate,
                                      onDateSelected: (date) {
                                        cubit.setSelectedDate(date);
                                      },
                                    )
                                  : const Center(child: Text('No available dates')),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              Text("اختيار التوقيت", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              selectedSession != null
                                  ? SessionList(
                                      availableSession: selectedSession,
                                      selectedSessionId: cubit.selectedSessionId,
                                      onTimeSelected: (sessionId) {
                                        cubit.setSelectedSessionId(sessionId);
                                      },
                                    )
                                  : const Center(child: Text('No available times')),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              Text("التعليقات", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              Container(
                                height: Responsive.screenHeight(context) * 0.47,
                                child: CommentsWidget(stadiumId: stadium.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: Responsive.screenHeight(context) * 0.1,
                      child: Card(
                        margin: EdgeInsets.zero,
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocConsumer<ReverseRequestCubit, ReverseRequestState>(
                                listener: (context, state) {
                                  if (state is ReverseRequestSuccess) {
                                    _showReservationStatusDialog(context, 'تم الحجز بنجاح', 'Request sent successfully');
                                  } else if (state is ReverseRequestError) {
                                    _showReservationStatusDialog(context, 'خطأ', 'حدث خطأ');
                                  }
                                },
                                builder: (context, state) {
                                  return CustomButton(
                                    onPress: () {
                                      _showReservationDialog(context, stadium, cubit.selectedDate, cubit.selectedSessionId);
                                    },
                                    text: "حجز",
                                    color: Constants.mainColor,
                                    textColor: Colors.white,
                                    height: Responsive.screenHeight(context) * 0.06,
                                    width: Responsive.screenWidth(context) * 0.4,
                                  );
                                },
                              ),
                              Text(
                                "${stadium.sessionPrice}دينار",
                                style: TextStyle(fontSize: Responsive.textSize(context, 22), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is StaduimDetailLoadedEmptySession) {
              final stadium = state.stadiumInfo;

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: stadium.images.isNotEmpty && stadium.images[0].isNotEmpty
                        ? Image.network(
                            stadium.images[0],
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: Responsive.screenHeight(context) * 0.25,
                                color: Colors.grey,
                                child: const Center(child: Text('No image available', style: TextStyle(color: Colors.white))),
                              );
                            },
                          )
                        : Container(
                            height: Responsive.screenHeight(context) * 0.25,
                            color: Colors.grey,
                            child: const Center(child: Text('No image available', style: TextStyle(color: Colors.white))),
                          ),
                  ),
                ],
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stadium.name, style: TextStyle(fontSize: Responsive.textSize(context, 18), fontWeight: FontWeight.bold)),
                              SizedBox(height: Responsive.screenHeight(context) * 0.015),
                              Row(
                                children: [
                                  SvgPicture.asset(AppPhotot.locationIco),
                                  SizedBox(width: Responsive.screenWidth(context) * 0.02),
                                  Text(stadium.address, style: TextStyle(fontSize: Responsive.textSize(context, 14))),
                                ],
                              ),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              StadiumInfoSummary(
                                totalReservations: stadium.totalReservations,
                                avgReviews: stadium.avgReviews,
                                totalReviews: stadium.totalReviews,
                              ),
                              SizedBox(height: Responsive.screenHeight(context) * 0.04),
                              const Center(child: Text('هاذا الملعب غير متوفر للحجز حاليا')),
                              SizedBox(height: Responsive.screenHeight(context) * 0.04),
                              Text("التعليقات", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                              SizedBox(height: Responsive.screenHeight(context) * 0.02),
                              Container(
                                height: Responsive.screenHeight(context) * 0.47,
                                child: CommentsWidget(stadiumId: stadium.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: Responsive.screenHeight(context) * 0.1,
                      child: Card(
                        margin: EdgeInsets.zero,
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocConsumer<ReverseRequestCubit, ReverseRequestState>(
                                listener: (context, state) {
                                  if (state is ReverseRequestSuccess) {
                                    _showReservationStatusDialog(context,"تم الحجز", 'تم الحجز بنجاح');
                                  } else if (state is ReverseRequestError) {
                                    _showReservationStatusDialog(context, 'خطأ',"حدث خطأ");
                                  }
                                },
                                builder: (context, state) {
                                  return CustomButton(
                                    onPress: () {
                                      _showReservationDialog(context, stadium, cubit.selectedDate, cubit.selectedSessionId);
                                    },
                                    text: "حجز",
                                    color: Constants.mainColor,
                                    textColor: Colors.white,
                                    height: Responsive.screenHeight(context) * 0.06,
                                    width: Responsive.screenWidth(context) * 0.4,
                                  );
                                },
                              ),
                              Text(
                                "${stadium.sessionPrice}دينار",
                                style: TextStyle(fontSize: Responsive.textSize(context, 22), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
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

  void _showReservationDialog(BuildContext context, stadium, String selectedDate, int selectedSessionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'تأكيد الحجز',
          content: 'اسم الملعب: ${stadium.name}\nعنوان الملعب: ${stadium.address}\nالتاريخ: $selectedDate\nالتوقيت: $selectedSessionId',
          canceText: 'إغلاق',
          confirmText: 'تأكيد',
          onConfirm: () {
            Navigator.of(context).pop();
            context.read<ReverseRequestCubit>().sendReverseRequest(
              stadium.id,
              selectedDate,
              selectedSessionId,
              true,
              2,
            );
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

  void _showReservationStatusDialog(BuildContext context, String title, String message) {
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