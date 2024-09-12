import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import '../../../../utilits/images.dart';
import '../../../../utilits/responsive.dart';
import '../../widget/coustom_appbar.dart';

class ProfileAppBar {
  static PreferredSizeWidget build(BuildContext context) {
    return AppBar(automaticallyImplyLeading: false,
      title: BlocBuilder<FetchProfileCubit, FetchProfileState>(
        builder: (context, state) {
          if (state is FetchProfileLoading) {
            return CoustomAppBr(
              title: "انشئ حساب و استمتع",
              logo: AppPhotot.notificationLogo,
              isLoading: true,
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
            );
          } else if (state is FetchProfileError) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "انشئ حساب و استمتع",
              logo: AppPhotot.notificationLogo,
            );
          } else if (state is ProfileSocketExceptionError) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "لا يوجد اتصال بالانترنت",
              logo: AppPhotot.notificationLogo,
            );
          } else if (state is FetchProfileLoaded) {
            return CoustomAppBr(
              title: "اهلا وسهلا ,",
              userName: state.userInfo.firstName,
              logo: AppPhotot.notificationLogo,
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
            );
          } else if (state is FetchProfileEmpty) {
            return CoustomAppBr(
              height: Responsive.screenHeight(context) * 0.045,
              width: Responsive.screenHeight(context) * 0.045,
              title: "انشئ حساب و استمتع",
              logo: AppPhotot.notificationLogo,
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}