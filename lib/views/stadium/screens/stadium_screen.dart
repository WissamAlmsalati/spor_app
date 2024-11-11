import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import 'package:sport/controller/ads_controler/ads_photos_cubit.dart';
import 'package:sport/controller/fetch_favorite/fetch_favorite_cubit.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/stadium/screens/widget/favorite_staduim.dart';
import 'package:sport/views/stadium/screens/widget/profile_appbar.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';

import '../../recomended_staduim/recomended_staduim_screeen.dart';
import '../../search_screen/widget/ads_photo_cursol.dart';
import '../widget/coustom_appbar.dart';
import '../widget/logo_text.dart';

class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<FetchRecomendedStaduimCubit>().fetchRecomendedStaduims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      title: BlocBuilder<FetchProfileCubit, FetchProfileState>(
        builder: (context, state) {
          if (state is FetchProfileLoading) {
            return CoustomAppBr(
              title: "انشئ حساب و استمتع",
              isLoading: true,
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              onPressedFav: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()));
              },
              isHomeScreen: true,
            );
          } else if (state is FetchProfileError) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "انشئ حساب و استمتع",
              isHomeScreen: true,
            );
          } else if (state is ProfileSocketExceptionError) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "لا يوجد اتصال بالانترنت",
              isHomeScreen: true,
            );
          } else if (state is FetchProfileLoaded) {
            return CoustomAppBr(
              title: "اهلا وسهلا ,",
              userName: state.userInfo.firstName,
              onPressedFav: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()));
              },
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              isHomeScreen: true,
            );
          } else if (state is FetchProfileEmpty) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "انشئ حساب و استمتع",
              isHomeScreen: true,
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            _refreshData(context);
            return Future<void>.value();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.screenWidth(context) * 0.040,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.02,
                    ),
                    child: OpenContainer(
                      closedElevation: 0,
                      openElevation: 0,
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.022),
                      ),
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.05),
                      ),
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: const Duration(milliseconds: 300),
                      openBuilder: (context, _) => StadiumSearchScreen(),
                      closedBuilder: (context, openContainer) => SearchFieldWidget(
                        controller: null,
                        onChanged: (value) {},
                        enabled: false,
                        onTap: openContainer,
                      ),
                    ),
                  ),
                  const LogoText(
                    logo: AppPhotot.cupLogo,
                    text: "عروض خاصة",
                  ),
                  AdsCarouselSlider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "افضل الملاعب",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black ,fontWeight: FontWeight.w500  ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RecomendedStadiumScreen()),
                          );
                        },
                        child: Text(
                          "عرض الكل",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Constants.mainColor ,fontWeight: FontWeight.w900  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.005,
                  ),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.48,

                      child: const RecomendedStaduimsList(isInHomeScreen: true,)),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


