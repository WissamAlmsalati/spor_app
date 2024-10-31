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

class ConfairmChangePass extends StatelessWidget {
  const ConfairmChangePass({super.key});

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
                left: Responsive.screenHeight(context) * 0.02,
                right: Responsive.screenHeight(context) * 0.02,
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
                      color: Constants.mainColor, isHomeScreen:  false,),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.03,
                  ),
                  SvgPicture.asset(
                    AppPhotot.changePass,
                    height: Responsive.screenHeight(context) * 0.10,
                    width: Responsive.screenHeight(context) * 10,
                  ),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.03,
                  ),
                  const Text(
                    'اعدت تعين كلمة المرور',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: Responsive.screenHeight(context) * 0.3,
                  ),
                  FormDecoration(
                    height: Responsive.screenHeight(context) * 0.0430,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Responsive.screenHeight(context) * 0.06,
                        right: 20,
                        left: 20,
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _oldpassword,
                            labelText: "كلمة المرور الجديدة",
                            validatorText: " كلمة المرور الجديدة مطلوبة",
                          ),
                          SizedBox(
                            height: Responsive.screenHeight(context) * 0.9,
                          ),


                          SizedBox(
                            height: Responsive.screenHeight(context) * 0.29,
                          ),
                          CustomButton(
                            text: 'حفظ',
                            onPress: () {
                              Navigator.pushNamed(context, '/otp');
                            },
                            color: Constants.mainColor,
                            textColor: Colors.white,
                            height: Responsive.screenHeight(context) * 0.53,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: Responsive.screenHeight(context) * 0.29,
                          ),

                        ],
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