import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../utilits/responsive.dart';
import '../auth/widgets/coustom_button.dart';
import '../auth/widgets/coustom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/profile/fetch_profile_cubit.dart';
import '../../../controller/profile_picture/profile_picture_cubit.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  AccountDetailsState createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: Responsive.blockHeight(context) * 2,
            right: Responsive.blockHeight(context) * 2,
          ),
          child: Column(
            children: [
              CoustomAppBr(
                onPressed: () {
                  Navigator.pop(context);
                },
                logo: AppPhotot.arrowBack,
                title: 'الحساب',
                color: Constants.mainColor,
                height: Responsive.screenHeight(context) * 0.045,
                width: Responsive.screenHeight(context) * 0.045,
                isHomeScreen: false,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.10,
                    ),
                    child: FormDecoration(
                      height: Responsive.screenHeight(context) * 0.37,
                      width: Responsive.screenWidth(context) * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: Responsive.screenHeight(context) * 0.0254,
                          right: Responsive.screenWidth(context) * 0.0544,
                          left: Responsive.screenWidth(context) * 0.054,
                        ),
                        child: SizedBox(
                          height: Responsive.screenHeight(context) * 0.044,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                controller: _name,
                                labelText: "الاسم",
                                validatorText: "الاسم مطلوب",
                                labelSize: Responsive.textSize(context, 8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم مطلوب';
                                  }
                                  return null;
                                },
                                hintSize: Responsive.textSize(context, 8),
                                validatorSize: Responsive.textSize(context, 6),
                              ),
                              CustomTextField(
                                controller: _phone,
                                labelText: "رقم الهاتف",
                                validatorText: "رقم الهاتف مطلوب",
                                labelSize: Responsive.textSize(context, 8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'رقم الهاتف مطلوب';
                                  }
                                  return null;
                                },
                                hintSize: Responsive.textSize(context, 8),
                                validatorSize: Responsive.textSize(context, 6),
                              ),
                              CustomButton(
                                text: 'تاكيد التغييرات',
                                onPress: () {
                                  // Add your confirmation logic here
                                },
                                textSize: Responsive.textSize(context, 14),
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                textColor: Colors.black,
                                height: Responsive.screenHeight(context) * 0.053,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<FetchProfileCubit, FetchProfileState>(
                    builder: (context, state) {
                      return Positioned(
                        top: Responsive.screenHeight(context) * 0.054,
                        right: Responsive.screenWidth(context) * 0.05,
                        child: GestureDetector(
                          onTap: () => context.read<ProfilePictureCubit>().pickImage(),
                          child: CircleAvatar(
                            radius: Responsive.screenHeight(context) * 0.04,
                            backgroundColor: Constants.mainColor,
                            child: BlocBuilder<ProfilePictureCubit, ProfilePictureState>(
                              builder: (context, profileState) {
                                if (profileState is ProfilePictureSelected) {
                                  return CircleAvatar(
                                    radius: Responsive.screenHeight(context) * 0.037,
                                    backgroundImage: FileImage(File(profileState.imagePath)),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: Responsive.screenHeight(context) * 0.037,
                                    backgroundImage: state is FetchProfileLoaded
                                        ? NetworkImage(state.userInfo.image)
                                        : const AssetImage(AppPhotot.userAvatar) as ImageProvider,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: Responsive.blockHeight(context) * 3),
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/changePasswordScreen');
                },
                child: FormDecoration(
                  height: Responsive.blockHeight(context) * 7,
                  width: Responsive.screenWidth(context) * 0.99,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: Responsive.screenWidth(context) * 0.04,
                          left: Responsive.screenWidth(context) * 0.04,
                        ),
                        child: SvgPicture.asset(AppPhotot.profileLogo),
                      ),
                      SizedBox(height: Responsive.screenHeight(context) * 0.02),
                      Text(
                        'تغيير كلمة المرور',
                        style: TextStyle(
                          fontSize: Responsive.textSize(context, 14),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
