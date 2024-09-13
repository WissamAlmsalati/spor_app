import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import 'package:sport/views/search_screen/widget/HorizontalCalendar.dart';
import 'package:sport/views/search_screen/widget/screen_detail_shimmer.dart';
import 'package:sport/views/search_screen/widget/session_list.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_body.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_footer.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_header.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import 'package:sport/views/stadium/screens/widget/comments_widget.dart';
import '../../app/app_packges.dart';
import '../../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../../controller/add_to_favorit/favorite_mangment_cubit.dart';
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
        child: MultiBlocListener(
          listeners: [
            BlocListener<AddToFavoriteCubit, AddToFavoriteState>(
              listener: (context, state) {
                if (state is AdedToFavorite) {
                  Fluttertoast.showToast(
                    msg: 'Stadium added to favorites',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                  );
                } else if (state is RemovedFromFavorite) {
                  Fluttertoast.showToast(
                    msg: 'Stadium removed from favorites',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                  );
                }
              },
            ),
          ],
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

                return Column(
                  children: [

                    Expanded(
                      flex: 0,
                      child: SingleChildScrollView(
                        child: StadiumDetailHeader(
                          stadium: stadium,
                          stadiumId: stadiumId,
                        ),
                      ),
                    ),


                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.screenWidth(context) * 0.04,
                          right: Responsive.screenWidth(context) * 0.04,
                        ),
                        child: SingleChildScrollView(
                          child: StadiumDetailBody(
                            stadium: stadium,
                            sessions: sessions,
                            selectedSession: selectedSession,
                            cubit: cubit,
                          ),
                        ),
                      ),
                    ),

                    // Footer area
                    Flexible(
                      flex: 0, // Footer takes smaller space
                      child: StadiumDetailFooter(
                        stadium: stadium,
                        cubit: cubit,
                      ),
                    ),
                  ],
                );
              } else if (state is StaduimDetailLoadedEmptySession) {
                final stadium = state.stadiumInfo;
                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: StadiumDetailHeader(
                          stadium: stadium,
                          stadiumId: stadiumId,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stadium.name,
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Responsive.screenHeight(context) * 0.015),
                            Row(
                              children: [
                                SvgPicture.asset(AppPhotot.locationIco),
                                SizedBox(width: Responsive.screenWidth(context) * 0.02),
                                Text(
                                  stadium.address,
                                  style: TextStyle(
                                    fontSize: Responsive.textSize(context, 14),
                                  ),
                                ),
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
                            Text(
                              "التعليقات",
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: Responsive.screenHeight(context) * 0.02),

                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: StadiumDetailFooter(
                        stadium: stadium,
                        cubit: cubit,
                      ),
                    ),
                  ],
                );
              } else if (state is StaduimDetailError) {
                return Center(child: Text("حدث خطا ما"));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
