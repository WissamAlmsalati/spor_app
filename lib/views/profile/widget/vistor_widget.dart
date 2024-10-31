import 'package:flutter/material.dart';
import 'package:sport/views/profile/widget/profile_buttom.dart';
import '../../../utilits/images.dart';
import '../../../utilits/responsive.dart';

class Visitor extends StatelessWidget {
  const Visitor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileButton(
          icon: AppPhotot.startLg,
          text: 'قيم التطبيق',
          onPressed: () {},
          fontsize: Responsive.textSize(context, 16),
        ),
    //ميزة للاصدار القادم
    //    ProfileButton(
    //      icon: AppPhotot.nighModLg,
    //      text: 'الوضع الليلي',
    //      hasLeading: true,
    //      fontsize: Responsive.textSize(context, 8),
    //      leadingIcon: AppPhotot.cupLogo,
    //      onSwitchToggle: () {
    //        BlocProvider.of<ThemeCubit>(context).toggleTheme(
    //          context,
    //          !(BlocProvider.of<ThemeCubit>(context).state.brightness ==
    //              Brightness.dark),
    //        );
    //      },
    //      onPressed: () {},
    //    ),
      ],
    );
  }
}
