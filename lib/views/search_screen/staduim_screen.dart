import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport/views/search_screen/widget/screen_detail_shimmer.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_body.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_footer.dart';
import 'package:sport/views/search_screen/widget/stadium_detail_header.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import '../../app/app_packges.dart';
import '../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../../controller/add_to_favorit/favorite_mangment_cubit.dart';
import '../stadium/screens/widget/comments_widget.dart';

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
                    msg: 'تم الاضافة الى المفضلة',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                  );
                } else if (state is RemovedFromFavorite) {
                  Fluttertoast.showToast(
                    msg: 'تم الحذف من المفضلة',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            StadiumDetailHeader(
                              stadium: stadium,
                              stadiumId: stadiumId,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Responsive.screenWidth(context) * 0.04,
                                right: Responsive.screenWidth(context) * 0.04,
                              ),
                              child: StadiumDetailBody(
                                stadium: stadium,
                                sessions: sessions,
                                selectedSession: selectedSession,
                                cubit: cubit,
                              ),

                            ),

                          ],
                        ),
                      ),
                    ),
                    StadiumDetailFooter(
                      stadium: stadium,
                      cubit: cubit,
                    ),
                  ],
                );
              } else if (state is StaduimDetailLoadedEmptySession) {
                final stadium = state.stadiumInfo;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StadiumDetailHeader(
                              stadium: stadium,
                              stadiumId: stadiumId,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Responsive.screenHeight(context) * 0.01,
                                left: Responsive.screenWidth(context) * 0.04,
                                right: Responsive.screenWidth(context) * 0.04,
                              ),
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
                                  SizedBox(
                                      height: Responsive.screenHeight(context) * 0.5,
                                      child: CommentsWidget(
                                          isScrollable: false,
                                          stadiumId: stadium.id)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StadiumDetailFooter(
                      stadium: stadium,
                      cubit: cubit,
                    ),
                  ],
                );
              } else if (state is StaduimDetailError) {
                return const Center(child: Text("حدث خطا ما"));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}