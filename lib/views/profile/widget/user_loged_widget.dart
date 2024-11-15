import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/profile/widget/profile_buttom.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/auth/authintication_cubit.dart';
import '../../../utilits/images.dart';
import '../../../utilits/responsive.dart';
import 'coustom_dialog.dart';

class UserLogged extends StatelessWidget {
  const UserLogged({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.screenHeight(context) * 0.29,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileButton(
            fontsize: Responsive.textSize(context, 16),
            icon: AppPhotot.profileLg,
            text: 'معلومات الحساب',
            onPressed: () {
              Navigator.pushNamed(context, '/accountDetails');
            },
          ),
          ProfileButton(
            icon: AppPhotot.walletLg,
            text: 'المحفظة',
            fontsize: Responsive.textSize(context, 16),

            onPressed: () {
              Navigator.pushNamed(context, '/walletScreen');
            },
          ),
          ProfileButton(
            icon: AppPhotot.startLg,
            text: 'قيم التطبيق',
            onPressed: () async {
              const googlePlayUrl = 'https://play.google.com/store/apps/details?id=spor.app';
              const appStoreUrl = 'https://apps.apple.com/app/id1234567890'; // Replace with your App Store URL

              final url = Platform.isIOS ? appStoreUrl : googlePlayUrl;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            fontsize: Responsive.textSize(context, 16),

            //ميزة للاصدار القادم
          ),
          //  ProfileButton(
          //    fontsize: Responsive.textSize(context, 8),
          //
          //    icon: AppPhotot.nighModLg,
          //    text: 'الوضع الليلي',
          //    hasLeading: true,
          //    leadingIcon: AppPhotot.cupLogo,
          //    onSwitchToggle: () {
          //      BlocProvider.of<ThemeCubit>(context).toggleTheme(
          //        context,
          //        !(BlocProvider.of<ThemeCubit>(context).state.brightness ==
          //            Brightness.dark),
          //      );
          //    },
          //    onPressed: () {},
          //  ),
          ProfileButton(
            fontsize: Responsive.textSize(context, 16),
            icon: AppPhotot.logoutLg,
            text: 'تسجيل الخروج',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: 'هل انت متأكد من تسجيل الخروج',
                    content: 'لا تطل علبنا الغيبة',
                    confirmText: 'خروج',
                    onCancel: () => Navigator.pop(context),
                    onConfirm: () {
                      context.read<AuthenticationCubit>().logOut(context);
                    },
                    canceText: 'الغاء',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
