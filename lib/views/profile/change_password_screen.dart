import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/profile/widget/coustom_dialog.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../utilits/responsive.dart';
import '../auth/widgets/coustom_button.dart';
import '../auth/widgets/coustom_text_field.dart';
import '../../controller/change_pass_controler/change_password_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.screenWidth(context) * 0.04,
              right: Responsive.screenWidth(context) * 0.04,
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
                  width: Responsive.screenHeight(context) * 0.045, isHomeScreen: false,
                ),
                SizedBox(
                  height: Responsive.screenHeight(context) * 0.03,
                ),
                SvgPicture.asset(
                  AppPhotot.changePass,
                  height: Responsive.screenHeight(context) * 0.10,
                  width: Responsive.screenWidth(context) * 0.10,
                ),
                SizedBox(
                  height: Responsive.screenHeight(context) * 0.03,
                ),
                Text(
                  'تغيير كلمة المرور',
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 24),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: Responsive.screenHeight(context) * 0.04,
                ),
                BlocProvider(
                  create: (context) => ChangePasswordCubit(),
                  child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
                    listener: (context, state) {
                      if (state is ChangePasswordSuccess) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'نجاح',
                              content: 'تم تغيير كلمة المرور بنجاح',
                              canceText: 'موافق',
                              confirmText: null,
                              color: Constants.mainColor,
                              borderColor: Constants.mainColor,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else if (state is ChangePasswordError) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'خطأ',
                              content: "كلمة السر القديمة غير صحيحة",
                              canceText: 'الغاء',
                              confirmText: 'حاول مرة اخرى',
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                context.read<ChangePasswordCubit>().changePassword(
                                  _oldPassword.text,
                                  _newPassword.text,
                                );
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                    child: FormDecoration(
                      height: Responsive.screenHeight(context) * 0.43,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: Responsive.screenWidth(context) * 0.05,
                          left: Responsive.screenWidth(context) * 0.05,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                lableSize: Responsive.textSize(context, 8),
                                hintSize: Responsive.textSize(context, 8),
                                controller: _oldPassword,
                                labeltext: "كلمة السر القديمة",
                                validatorText: "كلمة السر القديمة مطلوبة",
                              ),
                              CustomTextField(
                                lableSize: Responsive.textSize(context, 8),
                                hintSize: Responsive.textSize(context, 8),
                                controller: _newPassword,
                                labeltext: "كلمة السر الجديدة",
                                validatorText: "ادخل كلمة السر الجديدة",
                              ),
                              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                                builder: (BuildContext context, ChangePasswordState state) {
                                  if (state is ChangePasswordLoading) {
                                    return LoadingAnimation(
                                      size: Responsive.screenWidth(context) * 0.08,
                                      color: Constants.mainColor,
                                    );
                                  } else {
                                    return CustomButton(
                                      text: 'حفظ',
                                      onPress: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<ChangePasswordCubit>().changePassword(
                                            _oldPassword.text,
                                            _newPassword.text,
                                          );
                                        }
                                      },
                                      textSize: Responsive.textSize(context, 14),
                                      fontWeight: FontWeight.w600,
                                      color: Constants.mainColor,
                                      textColor: Colors.white,
                                      height: Responsive.screenHeight(context) * 0.048,
                                      width: double.infinity,
                                    );
                                  }
                                },
                              ),
                              CustomButton(
                                text: 'نسيت كلمة المرور',
                                onPress: () {},
                                color: Colors.white,
                                textColor: Constants.txtColor,
                                fontWeight: FontWeight.w600,
                                textSize: Responsive.textSize(context, 14),
                                height: Responsive.screenHeight(context) * 0.048,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
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