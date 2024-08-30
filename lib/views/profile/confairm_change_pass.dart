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
                left: Responsive.blockHeight(context) * 2,
                right: Responsive.blockHeight(context) * 2,
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
                    height: Responsive.blockHeight(context) * 3,
                  ),
                  SvgPicture.asset(
                    AppPhotot.changePass,
                    height: Responsive.blockHeight(context) * 10,
                    width: Responsive.blockHeight(context) * 10,
                  ),
                  SizedBox(
                    height: Responsive.blockHeight(context) * 3,
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
                    height: Responsive.blockHeight(context) * 3,
                  ),
                  FormDecoration(
                    height: Responsive.blockHeight(context) * 30,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Responsive.blockHeight(context) * 6,
                        right: 20,
                        left: 20,
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _oldpassword,
                            labeltext: "كلمة المرور الجديدة",
                            validatorText: " كلمة المرور الجديدة مطلوبة",
                          ),
                          SizedBox(
                            height: Responsive.blockHeight(context) * 2.9,
                          ),


                          SizedBox(
                            height: Responsive.blockHeight(context) * 2.9,
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
                          SizedBox(
                            height: Responsive.blockHeight(context) * 2.9,
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