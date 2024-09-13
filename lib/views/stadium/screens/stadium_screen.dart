import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import 'package:sport/views/stadium/screens/widget/cursol_photo.dart';
import 'package:sport/views/stadium/screens/widget/favorite_staduim.dart';
import 'package:sport/views/stadium/screens/widget/profile_appbar.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';
import '../../../controller/ads_controler/ads_photos_cubit.dart';
import '../../../controller/fetch_favorite/fetch_favorite_cubit.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/images.dart';
import '../../../utilits/responsive.dart';
import '../../search_screen/search_screen.dart';
import '../../search_screen/widget/ads_photo_cursol.dart';
import '../widget/logo_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
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
              padding: EdgeInsets.only(
                left: Responsive.screenWidth(context) * 0.040,
                right: Responsive.screenWidth(context) * 0.040,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.02,
                    ),
                    child: OpenContainer(
                      closedElevation: 0, // Removes shadow when closed
                      openElevation: 0,   // Removes shadow when opened
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.022),
                      ),
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.05),
                      ),
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: const Duration(milliseconds: 300), // Adjust duration for smoothness
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
                  const LogoText(
                    logo: AppPhotot.hearth,
                    text: " الملاعب المفضلة",
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: FavoriteStadium(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}