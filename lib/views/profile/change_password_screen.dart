// change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';

import '../../utilits/constants.dart';
import '../auth/widgets/coustom_button.dart';
import '../auth/widgets/coustom_text_field.dart';
import '../auth/widgets/form_decoration.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _oldpassword = TextEditingController();
    final TextEditingController _newpassword = TextEditingController();
    return Scaffold(
      body:SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.screenWidth(context) * 0.04,
              right: Responsive.screenWidth(context)* 0.04,
            ),
            child: Column(
              children: [
                CoustomAppBr(
                  height: 20,
                  width: 20,
                    logo: AppPhotot.backArrow ,
                    title: "كلمة المرور",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Constants.mainColor),
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
                    fontSize: Responsive.textSize(context, 6),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: Responsive.screenHeight(context) * 0.04,
                ),
                FormDecoration(
                  height: Responsive.screenHeight(context) * 0.43,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Responsive.screenWidth(context)*0.05,
                      left:Responsive.screenWidth(context)*0.05,
                    ),
                    child: Container(
                      height: Responsive.screenHeight(context) * 0.43,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                            controller: _oldpassword,
                            labeltext: "الاسم",
                            validatorText: "الاسم مطلوب",
                          ),
                          CustomTextField(
                            controller: _newpassword,
                            labeltext: "رقم الهاتف",
                            validatorText: "رقم الهاتف مطلوب",
                          ),
                          CustomButton(
                            text: 'حفظ',
                            onPress: () {
                              Navigator.pushNamed(context, '/otp');
                            },
                            color: Constants.mainColor,
                            textColor: Colors.white,
                            height: Responsive.blockHeight(context) * 5.3,
                            width: double.infinity,
                          ),
                          CustomButton(
                            text: 'نسيت كلمة المرور',
                            onPress: () {},
                            color: Colors.white,
                            textColor: Constants.txtColor,
                            fontWeight: FontWeight.w600,
                            textSize: 16,
                            height: Responsive.blockHeight(context) * 5.3,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}