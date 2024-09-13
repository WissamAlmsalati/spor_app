import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import 'package:sport/views/search_screen/widget/HorizontalCalendar.dart';
import 'package:sport/views/search_screen/widget/session_list.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import 'package:sport/views/stadium/screens/widget/comments_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/app_packges.dart';
import '../../../search_screen/staduim_screen.dart';

class FavoriteStadium extends StatelessWidget {
  const FavoriteStadium({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToFavoriteCubit, AddToFavoriteState>(
      listener: (context, state) {
        if (state is AdedToFavorite) {
          context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
        }
      },
      child: BlocBuilder<FetchFavoriteCubit, FetchFavoriteState>(
        builder: (BuildContext context, state) {
          if (state is FetchFavoriteLoading) {
            return SizedBox(
              height: Responsive.screenHeight(context) * 0.40,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: 4, // Placeholder item count
                itemBuilder: (context, index) {
                  return const ShimmerPlaceholder();
                },
              ),
            );
          } else if (state is FavoriteSocketExceptionError) {
            return SizedBox(
              height: Responsive.screenHeight(context) * 0.41,
              width: Responsive.screenWidth(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    'لا يوجد اتصال بالانترنت',
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is FetchFavoriteLoaded) {
            if (state.stadiums.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.heart_broken_outlined, color: Constants.mainColor, size: Responsive.screenHeight(context) * 0.2),
                  Text(
                    'لا توجد ملاعب مفضلة',
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }
            double gridHeight = (state.stadiums.length / 2).ceil() * (Responsive.screenHeight(context) * 0.25);
            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: state.stadiums.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StadiumDetailScreen(stadiumId: state.stadiums[index].id),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.04),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: Responsive.screenHeight(context) * 0.12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Responsive.screenWidth(context) * 0.04),
                                      topRight: Radius.circular(Responsive.screenWidth(context) * 0.04),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(state.stadiums[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: Responsive.screenWidth(context) * 0.04,
                                  top: Responsive.screenHeight(context) * 0.02,
                                  child: SvgPicture.asset(
                                    AppPhotot.fillFav,
                                    color: Colors.red,
                                    width: Responsive.screenWidth(context) * 0.025,
                                    height: Responsive.screenHeight(context) * 0.020,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Responsive.screenHeight(context) * 0.01,
                                right: Responsive.screenWidth(context) * 0.018,
                              ),
                              child: Text(
                                state.stadiums[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  fontSize: Responsive.textSize(context, 14),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Responsive.screenHeight(context) * 0.008,
                                right: Responsive.screenWidth(context) * 0.018,
                              ),
                              child: Text(
                                state.stadiums[index].isAvailable ? 'متوفر للحجز' : 'غير متوفر للحجز',
                                style: GoogleFonts.cairo(
                                  fontSize: Responsive.textSize(context, 10),
                                  fontWeight: FontWeight.w500,
                                  color: state.stadiums[index].isAvailable ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is UnAuthorizedError) {
            return SizedBox(
              height: Responsive.screenHeight(context) * 0.41,
              width: Responsive.screenWidth(context),
              child: Center(
                child: Text(
                  'قم ب انشاء حساب لعرض الملاعب المفضلة',
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else if (state is FetchFavoriteError) {
            return Center(child: Text(state.message));
          } else if (state is FavoriteSocketExceptionError) {
            return const Center(child: Text('لا يوجد اتصال بالانترنت'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Responsive.screenHeight(context) * 0.12,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.01,
                right: Responsive.screenWidth(context) * 0.018,
              ),
              child: Container(
                width: Responsive.screenWidth(context) * 0.3,
                height: Responsive.screenHeight(context) * 0.02,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.01,
                right: Responsive.screenWidth(context) * 0.018,
              ),
              child: Container(
                width: Responsive.screenWidth(context) * 0.2,
                height: Responsive.screenHeight(context) * 0.02,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}