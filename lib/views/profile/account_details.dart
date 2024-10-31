import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/profile/widget/coustom_dialog.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPhotoSelected = false;
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _firstName.text.isNotEmpty || _lastName.text.isNotEmpty || _isPhotoSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    _firstName.addListener(_validateFields);
    _lastName.addListener(_validateFields);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: Responsive.screenHeight(context) * 0.02,
            right: Responsive.screenHeight(context) * 0.02,
          ),
          child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                context.read<FetchProfileCubit>().fetchProfileInfo();
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      title: "نجاح",
                      content: "تم تحديث الحساب بنجاح",
                      canceText: "حسنا",
                      borderColor: Constants.mainColor,
                      textColor: Constants.mainColor,
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              } else if (state is UpdateProfileError) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: _firstName,
                                  labelText: "الاسم الأول",
                                  labelSize: Responsive.textSize(context, 8),
                                  hintSize: Responsive.textSize(context, 8),
                                  validatorSize: Responsive.textSize(context, 6), validatorText: "الرجاء ادخال الاسم الأول",
                                ),
                                CustomTextField(
                                  controller: _lastName,
                                  labelText: "الاسم الأخير",
                                  labelSize: Responsive.textSize(context, 8),
                                  hintSize: Responsive.textSize(context, 8),
                                  validatorSize: Responsive.textSize(context, 6), validatorText: "الرجاء ادخال الاسم الأخير",
                                ),
                                CustomButton(
                                  text: 'تاكيد التغييرات',
                                  onPress: _isButtonEnabled
                                      ? () {
                                          if (_formKey.currentState!.validate()) {
                                            final profilePictureState = context.read<ProfilePictureCubit>().state;
                                            if (profilePictureState is ProfilePictureSelected) {
                                              context.read<ProfilePictureCubit>().uploadImage(
                                                    profilePictureState.imagePath,
                                                    context,
                                                  );
                                            }
                                            if (_firstName.text.isNotEmpty || _lastName.text.isNotEmpty) {
                                              context.read<UpdateProfileCubit>().updateProfile(
                                                    _firstName.text,
                                                    _lastName.text,
                                                    context,
                                                  );
                                            }
                                          }
                                        }
                                      : null,
                                  textSize: Responsive.textSize(context, 14),
                                  fontWeight: FontWeight.w400,
                                  color: _isButtonEnabled ? Constants.mainColor : Colors.grey,
                                  hasBorder: true,
                                  borderColor: Constants.mainColor,
                                  textColor: _isButtonEnabled ? Colors.white : Colors.black,
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
                SizedBox(height: Responsive.screenHeight(context) * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/changePasswordScreen');
                  },
                  child: FormDecoration(
                    height: Responsive.screenHeight(context) * 0.07,
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
      ),
    );
  }
}