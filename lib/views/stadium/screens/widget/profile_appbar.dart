import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import '../../../../utilits/responsive.dart';
import '../../widget/coustom_appbar.dart';
import 'favorite_staduim.dart';

class ProfileAppBar {
  static PreferredSizeWidget build(BuildContext context) {
    return AppBar(
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
              }, isHomeScreen: true,
            );
          } else if (state is FetchProfileError) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "انشئ حساب و استمتع", isHomeScreen: true,
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
              width: Responsive.screenHeight(context) * 0.045, isHomeScreen: true,
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
    );
  }
}


class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الملاعب المفضلة',
          style: TextStyle(
            fontSize: Responsive.textSize(context, 16),
          ),
        ),
      ),
      body: const FavoriteStadium(),
    );
  }
}
