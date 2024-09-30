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
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CoustomAppBr(
                      title: 'الحساب',
                      color: Constants.mainColor,
                      height: Responsive.screenHeight(context) * 0.045,
                      width: Responsive.screenHeight(context) * 0.045, isHomeScreen: false,
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Constants.mainColor,
                          fontWeight: FontWeight.w600,

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
