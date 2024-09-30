import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import 'package:sport/controller/ads_controler/ads_photos_cubit.dart';
import 'package:sport/controller/fetch_favorite/fetch_favorite_cubit.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/stadium/screens/widget/profile_appbar.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';

import '../../recomended_staduim/recomended_staduim_screeen.dart';
import '../../search_screen/widget/ads_photo_cursol.dart';
import '../widget/logo_text.dart';

class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<FetchRecomendedStaduimCubit>()..fetchRecomendedStaduims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar.build(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(context),
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black  ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecomendedStadiumScreen()),
                          );
                        },
                        child: Text(
                          "عرض الكل",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Constants.mainColor  ),
                        ),
                      ),
                    ],
                  ),
                  const RecommendedStadiums(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


