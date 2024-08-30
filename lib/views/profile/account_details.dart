import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../utilits/responsive.dart';
import '../auth/widgets/coustom_button.dart';
import '../auth/widgets/coustom_text_field.dart';

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
                height: 20,
                width: 20,
                logo: AppPhotot.backArrow,
                title: "الحساب",
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Constants.mainColor,
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
                      child: Padding(
                        padding: EdgeInsets.only(
                          top:Responsive.screenHeight(context) * 0.0254,

                          right: Responsive.screenWidth(context) * 0.054,
                          left: Responsive.screenWidth(context) * 0.054,
                        ),
                        child: SizedBox(
                          height: Responsive.screenHeight(context) * 0.044,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                controller: _name,
                                labeltext: "الاسم",
                                validatorText: "الاسم مطلوب",
                                lableSize: Responsive.textSize(context, 8),
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
                                labeltext: "رقم الهاتف",
                                validatorText: "رقم الهاتف مطلوب",
                                lableSize: Responsive.textSize(context, 8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم مطلوب';
                                  }
                                  return null;
                                },
                                hintSize: Responsive.textSize(context, 8),
                                validatorSize: Responsive.textSize(context, 6),
                              ),

                              CustomButton(
                                text: 'تاكيد التغييرات',
                                onPress: () {},
                                textSize: Responsive.textSize(context, 3.5),
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
                  Positioned(
                    top: Responsive.screenHeight(context) * 0.054,
                    right: Responsive.screenWidth(context) * 0.05,
                    child: CircleAvatar(
                      radius: Responsive.screenHeight(context) * 0.04,
                      backgroundColor: Constants.mainColor,
                      child: CircleAvatar(
                        radius: Responsive.screenHeight(context) * 0.037,
                        backgroundImage: const AssetImage(AppPhotot.userAvatar),
                      ),
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
                          fontSize: Responsive.textSize(context, 3.4),
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