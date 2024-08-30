import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/controller/fetch_favorite/fetch_favorite_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import '../../../../controller/add_to_favorit/favorite_mangment_cubit.dart';
import '../../../../utilits/responsive.dart';
import '../../../search_screen/search_screen.dart';
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
      child: SingleChildScrollView(
        child: SizedBox(
          height: Responsive.screenHeight(context) * 0.35,
          width: double.infinity,
          child: BlocBuilder<FetchFavoriteCubit, FetchFavoriteState>(
            builder: (BuildContext context, state) {
              if (state is FetchFavoriteLoading) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.1,
                    mainAxisSpacing: 0.2,
                    childAspectRatio: 1,
                  ),
                  itemCount: 4, // Placeholder item count
                  itemBuilder: (context, index) {
                    return const ShimmerPlaceholder();
                  },
                );
              } else if (state is FavoriteSocketExceptionError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   SvgPicture.asset(
                      AppPhotot.wifiDisconnected,
                      height: Responsive.screenHeight(context) * 0.14,
                    ),
                    Text(
                      'لا يوجد اتصال بالانترنت',
                      style: TextStyle(
                        fontSize: Responsive.textSize(context, 12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else if (state is FetchFavoriteLoaded) {
                if (state.stadiums.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.heart_broken_outlined,color: Constants.mainColor,size: Responsive.screenHeight(context)*0.2,),
                        Text(
                          'لا توجد ملاعب مفضلة',
                          style: TextStyle(
                            fontSize: Responsive.textSize(context, 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.1,
                    mainAxisSpacing: 0.2,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.stadiums.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('Stadium ID: ${state.stadiums[index].id}');
                        }
                        if (kDebugMode) {
                          print('Stadium Name: ${state.stadiums[index].name}');
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StadiumDetailScreen(stadiumId: state.stadiums[index].id,),
                          ),
                        ).then((_) {
                          context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.screenWidth(context) * 0.04),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: Responsive.screenHeight(context) * 0.11,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            Responsive.screenWidth(context) * 0.04),
                                        topRight: Radius.circular(
                                            Responsive.screenWidth(context) * 0.04),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          state.stadiums[index].image,
                                        ),
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
                                  style: GoogleFonts.cairo(
                                    fontSize: Responsive.textSize(context, 8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Responsive.screenHeight(context) * 0.01,
                                  right: Responsive.screenWidth(context) * 0.018,
                                ),
                                child: Text(
                                  state.stadiums[index].isAvailable
                                      ? 'متوفر للحجز'
                                      : 'غير متوفر للحجز',
                                  style: GoogleFonts.cairo(
                                    fontSize: Responsive.textSize(context, 10),
                                    fontWeight: FontWeight.w500,
                                    color: state.stadiums[index].isAvailable
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is UnAuthorizedError) {
                return Center(
                    child: Text(
                      'قم ب انشاء حساب لعرض الملاعب المفضلة',
                      style: TextStyle(
                        fontSize: Responsive.textSize(context, 8),
                        fontWeight: FontWeight.bold,
                      ),
                    ));
              } else if (state is FetchFavoriteError) {
                return Center(child: Text(state.message));
              } else if (state is FavoriteSocketExceptionError) {
                return const Center(child: Text('لا يوجد اتصال بالانترنت'));
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
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

