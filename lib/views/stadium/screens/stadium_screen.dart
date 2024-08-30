import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import 'package:sport/views/stadium/screens/widget/cursol_photo.dart';
import 'package:sport/views/stadium/screens/widget/favorite_staduim.dart';
import 'package:sport/views/stadium/screens/widget/profile_appbar.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';
import '../../../controller/fetch_favorite/fetch_favorite_cubit.dart';
import '../../../utilits/images.dart';
import '../../../utilits/responsive.dart';
import '../../search_screen/search_screen.dart';
import '../widget/logo_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ProfileAppBar.build(context), // Use the static method
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.02,
                    ),

                    child: OpenContainer(
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.05),
                      ),
                        closedColor: Colors.white,
                      transitionType: ContainerTransitionType.fadeThrough,
                      transitionDuration: const Duration(milliseconds: 500), // Adjust duration for smoothness
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
                  CarouselPhoto(),
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