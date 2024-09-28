import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import '../../../controller/profile/fetch_profile_cubit.dart';
import '../../../controller/profile_picture/profile_picture_cubit.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            BlocBuilder<FetchProfileCubit, FetchProfileState>(
              builder: (context, state) {
                if (state is FetchProfileLoaded) {
                  return GestureDetector(
                    onTap: () => context.read<ProfilePictureCubit>().pickImage(),
                    child: CircleAvatar(
                      radius: Responsive.blockHeight(context) * 5,
                      backgroundImage: NetworkImage(state.userInfo.image),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => context.read<ProfilePictureCubit>().pickImage(),
                    child: CircleAvatar(
                      radius: Responsive.blockHeight(context) * 5,
                      backgroundImage: const AssetImage(AppPhotot.userAvatar) as ImageProvider,
                    ),
                  );
                }
              },
            ),
            ProfilePictureOverlay(
              onTap: () => context.read<ProfilePictureCubit>().pickImage(),
            ),
          ],
        ),
        SizedBox(
          height: Responsive.blockHeight(context) * 2,
        ),
        BlocBuilder<FetchProfileCubit, FetchProfileState>(
            builder: (context, state) {
          if (state is FetchProfileLoading) {
            return Center(
                child: LoadingAnimation(
              size: Responsive.screenWidth(context) * 0.1,
            ));
          } else if (state is FetchProfileLoaded) {
            return Column(
              children: [
                Text(
                  state.userInfo.firstName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.textSize(context, 30),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: Responsive.screenHeight(context) * 0.002,
                ),
                Text(
                  state.userInfo.phone,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Responsive.textSize(context, 20),
                    color: Colors.grey.withOpacity(0.9),
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
            ));
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
            ));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        }),
        SizedBox(
          height: Responsive.blockHeight(context) * 1,
        ),
        BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
          builder: (context, state) {
            if (state is ProfilePictureSelected) {
              return CustomButton(
                height: Responsive.screenWidth(context) * 0.1,
                color: Constants.mainColor,
                onPress: () {
                  context.read<ProfilePictureCubit>().uploadImage(state.imagePath, context);
                },
                text: "تغير الصورة",
                textColor: Colors.white,
                textSize: Responsive.textSize(context, 8),
                width: Responsive.screenWidth(context) * 0.31,
              );
            }
            return SizedBox.shrink();
          },
        ),
        SizedBox(
          height: Responsive.blockHeight(context) * 1,
        ),
      ],
    );
  }
}

class ProfilePictureOverlay extends StatelessWidget {
  final VoidCallback onTap;

  const ProfilePictureOverlay({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Responsive.blockHeight(context) * 5,
          height: Responsive.blockHeight(context) * 2.5,
          decoration: BoxDecoration(
            color: Constants.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Responsive.blockHeight(context) * 2.5),
              bottomRight: Radius.circular(Responsive.blockHeight(context) * 2.5),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: Responsive.blockHeight(context) * 2,
            ),
          ),
        ),
      ),
    );
  }
}