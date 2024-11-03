
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import '../../../controller/profile/fetch_profile_cubit.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<FetchProfileCubit, FetchProfileState>(
          builder: (context, state) {
            String imageUrl = '';

            if (state is FetchProfileLoaded) {
              imageUrl = state.userInfo.image;
            } else {
              imageUrl = AppPhotot.userAvatar;
            }

            return CircleAvatar(
              radius: Responsive.screenHeight(context) * 0.05,
              backgroundImage: NetworkImage(imageUrl),
            );
          },
        ),
        SizedBox(height: Responsive.screenHeight(context) * 0.02),
        BlocBuilder<FetchProfileCubit, FetchProfileState>(
          builder: (context, state) {
            if (state is FetchProfileLoading) {
              return Center(
                child: LoadingAnimation(
                  size: Responsive.screenWidth(context) * 0.1,
                ),
              );
            } else if (state is FetchProfileLoaded) {
              return Column(
                children: [
                  Text(
                    state.userInfo.firstName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: Responsive.screenHeight(context) * 0.002,
                  ),
                  Text(
                    state.userInfo.phone,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            } else if (state is ProfileSocketExceptionError) {
              return Center(
                child: Text(
                  'لا يوجد اتصال بالانترنت',
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            } else if (state is FetchProfileEmpty) {
              return Center(
                child: CustomButton(
                  height: Responsive.screenWidth(context) * 0.1,
                  color: Constants.mainColor,
                  onPress: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  text: "انشئ حساب",
                  textColor: Colors.white,
                  textSize: Responsive.textSize(context, 8),
                  width: Responsive.screenWidth(context) * 0.31,
                ),
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ],
    );
  }
}

class ProfilePictureOverlay extends StatelessWidget {
  final VoidCallback onTap;

  const ProfilePictureOverlay({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Responsive.screenHeight(context) * 0.5,
          height: Responsive.screenHeight(context) * 0.25,
          decoration: BoxDecoration(
            color: Constants.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Responsive.screenHeight(context) * 0.25),
              bottomRight: Radius.circular(Responsive.screenHeight(context) * 0.25),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: Responsive.screenHeight(context) * 0.2,
            ),
          ),
        ),
      ),
    );
  }
}