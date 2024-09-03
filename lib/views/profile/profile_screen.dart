import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/auth/authintication_cubit.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/profile/widget/user_info.dart';
import 'package:sport/views/profile/widget/user_loged_widget.dart';
import 'package:sport/views/profile/widget/vistor_widget.dart';
import '../../utilits/responsive.dart';
import '../stadium/widget/coustom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: Responsive.screenWidth(context) * 0.040,
            right: Responsive.screenWidth(context) * 0.040,
          ),
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, authState) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CoustomAppBr(
                      logo: AppPhotot.notificationLogo,
                      title: 'الحساب',
                      color: Constants.mainColor,
                      height: Responsive.screenHeight(context) * 0.045,
                      width: Responsive.screenHeight(context) * 0.045,
                    ),
                    SizedBox(
                      height: Responsive.screenHeight(context) * 0.01,
                    ),
                    const UserInfo(),
                    SizedBox(
                      height: Responsive.screenHeight(context) * 0.02,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'اعدادات عامة',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: Responsive.textSize(context, 18),
                          color: Constants.mainColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.screenHeight(context) * 0.02,
                    ),
                    authState is AuthenticationAuthenticated
                        ? const UserLogged()
                        : const Visitor(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
