import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/app_packges.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../../../utilits/texts.dart';
import '../functions/sign_up_fun.dart';
import '../widgets/CustomDatePickerField.dart';
import '../widgets/coustom_button.dart';
import '../widgets/coustom_text_field.dart';
import '../widgets/form_decoration.dart';
import '../widgets/logo_title_logo.dart';
import '../widgets/sign_up_form.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.screenWidth(context) * 0.07,
              vertical: Responsive.screenHeight(context) * 0.10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleLogoTitle(
                  logo: AppPhotot.signLogo,
                  title: AppText.signUptxt,
                  description: AppText.signUpdes,
                ),
                const SignUpForm(),
                SizedBox(height: Responsive.screenHeight(context) * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
