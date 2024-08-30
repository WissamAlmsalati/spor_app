import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';

import '../../../../utilits/images.dart';
import '../../../../utilits/loading_animation.dart';
import '../../../../utilits/responsive.dart';

import '../../widget/coustom_appbar.dart';



class ProfileAppBar {
  static Widget build(BuildContext context) {
    return BlocBuilder<FetchProfileCubit, FetchProfileState>(
      builder: (context, state) {
        if (state is FetchProfileLoading) {
          return CoustomAppBr(
            title: "انشئ حساب و استمتع",
            logo: AppPhotot.notificationLogo,
            isLoading: true,
            height: Responsive.screenHeight(context) * 0.070,
            width: Responsive.screenHeight(context) * 0.070,
          );
        } else if (state is FetchProfileError) {
          return const CoustomAppBr(
            title: "انشئ حساب و استمتع",
            logo: AppPhotot.notificationLogo,
          );
        } else if (state is ProfileSocketExceptionError) {
          return  const CoustomAppBr(
            title: "لا يوجد اتصال بالانترنت",
            logo: AppPhotot.notificationLogo,
          );
        } else if (state is FetchProfileLoaded) {
          return CoustomAppBr(
            title: "اهلا وسهلا ${state.userInfo.firstName}",
            logo: AppPhotot.notificationLogo,
            height: Responsive.screenHeight(context) * 0.070,
            width: Responsive.screenHeight(context) * 0.070,
          );
        } else if (state is FetchProfileEmpty) {
          return const CoustomAppBr(
            title: "انشئ حساب و استمتع",
            logo: AppPhotot.notificationLogo,
          );
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}


