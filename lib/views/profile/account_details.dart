import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../controller/update_profile/update_profile_cubit.dart';
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
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _isPhotoSelected = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
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
                                controller: _firstName,
                                labelText: "الاسم الأول",
                                validatorText: "الاسم الأول مطلوب",
                                labelSize: Responsive.textSize(context, 8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم الأول مطلوب';
                                  }
                                  return null;
                                },
                                hintSize: Responsive.textSize(context, 8),
                                validatorSize: Responsive.textSize(context, 6),
                              ),
                              CustomTextField(
                                controller: _lastName,
                                labelText: "الاسم الأخير",
                                validatorText: "الاسم الأخير مطلوب",
                                labelSize: Responsive.textSize(context, 8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم الأخير مطلوب';
                                  }
                                  return null;
                                },
                                hintSize: Responsive.textSize(context, 8),
                                validatorSize: Responsive.textSize(context, 6),
                              ),

                              CustomButton(
                                text: 'تاكيد التغييرات',
                                onPress: () {
                                  final profilePictureState = context.read<ProfilePictureCubit>().state;
                                  if (profilePictureState is ProfilePictureSelected) {
                                    context.read<ProfilePictureCubit>().uploadImage(
                                      profilePictureState.imagePath,
                                      context,
                                    );
                                  }
                                  context.read<UpdateProfileCubit>().updateProfile(
                                    _firstName.text,
                                    _lastName.text,
                                  );
                                },
                                textSize: Responsive.textSize(context, 14),
                                fontWeight: FontWeight.w400,
                                color: _isPhotoSelected ? Constants.mainColor : Colors.white,
                                hasBorder: true,
                                borderColor: Constants.mainColor,
                                textColor: _isPhotoSelected ? Colors.white : Constants.mainColor,
                                height: Responsive.screenHeight(context) * 0.053,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocListener<ProfilePictureCubit, ProfilePictureState>(
                    listener: (context, profileState) {
                      if (profileState is ProfilePictureSelected) {
                        setState(() {
                          _isPhotoSelected = true;
                        });
                      } else if (profileState is ProfilePictureUploaded) {
                        setState(() {
                          _isPhotoSelected = false;
                        });
                      }
                    },
                    child: BlocBuilder<FetchProfileCubit, FetchProfileState>(
                      builder: (context, state) {
                        return Positioned(
                          top: Responsive.screenHeight(context) * 0.04,
                          right: Responsive.screenWidth(context) * 0.05,
                          child: GestureDetector(
                            onTap: () => context.read<ProfilePictureCubit>().pickImage(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
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
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: Responsive.screenHeight(context) * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.blockHeight(context) * 3),
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