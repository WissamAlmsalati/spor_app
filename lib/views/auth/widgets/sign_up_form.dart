import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/auth/widgets/logo_title_logo.dart';
import '../../../app/app_packges.dart';
import '../../../utilits/texts.dart';
import '../functions/sign_up_fun.dart';
import 'CustomDatePickerField.dart';
import 'coustom_button.dart';
import 'coustom_text_field.dart';
import 'form_decoration.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController firstnameController = TextEditingController();
    final TextEditingController lastnameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();

    return FormDecoration(
      height: Responsive.screenHeight(context) * 0.55,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.screenWidth(context) * 0.05,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: firstnameController,
                labelText: 'الاسم',
                validatorText: 'الرجاء ادخال الاسم',
                validator: (value) =>
                    value == null || value.isEmpty ? 'الرجاء ادخال الاسم' : null,
              ),
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: lastnameController,
                keyboardType: TextInputType.name,
                labelText: 'اللقب',
                validatorText: 'الرجاء ادخال اللقب',
                validator: (value) =>
                    value == null || value.isEmpty ? 'الرجاء ادخال اللقب' : null,
              ),
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: phoneController,
                labelText: 'رقم الهاتف',
                validatorText: 'الرجاء ادخال رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'الرجاء ادخال رقم الهاتف' : null,
              ),
              CustomButton(
                fontWeight: FontWeight.w600,
                width: Responsive.screenWidth(context) * 0.9,
                height: Responsive.screenHeight(context) * 0.06,
                loadingSize: Responsive.screenHeight(context) * 0.04,
                loadingColor: Colors.white,
                text: 'انشاء حساب',
                color: Constants.mainColor,
                textSize: Responsive.textSize(context, 16),
                borderColor: Constants.secondaryColor,
                onPress: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordAndBirthDayScreen(
                        firstname: firstnameController,
                        lastname: lastnameController,
                        phoneController: phoneController,
                        birthdateController: birthdateController,
                      ),
                    ),
                    (route) => false,
                  );
                },
                textColor: Colors.white,
              ),
              CustomButton(
                fontWeight: FontWeight.w600,
                textSize: Responsive.textSize(context, 16),
                width: Responsive.screenWidth(context) * 0.9,
                height: Responsive.screenHeight(context) * 0.06,
                text: 'تسجيل الدخول',
                color: Constants.secondaryColor,
                borderColor: Constants.secondaryColor,
                onPress: () => Navigator.pushNamed(context, '/login'),
                textColor: Constants.thirdColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordAndBirthDayScreen extends StatelessWidget {
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController phoneController;
  final TextEditingController birthdateController;

  const PasswordAndBirthDayScreen({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.phoneController,
    required this.birthdateController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.screenWidth(context) * 0.07,
            vertical: Responsive.screenHeight(context) * 0.10,
          ),
          child: Column(
            children: [
              TitleLogoTitle(
                logo: AppPhotot.signLogo,
                title: AppText.signUptxt,
                description: AppText.signUpdes,
              ),              PasswordAndBirthDayForm(
                firstname: firstname,
                lastname: lastname,
                phoneController: phoneController,
                birthdateController: birthdateController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordAndBirthDayForm extends StatelessWidget {
  final TextEditingController firstname;
  final TextEditingController lastname;
  final TextEditingController phoneController;
  final TextEditingController birthdateController;

  const PasswordAndBirthDayForm({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.phoneController,
    required this.birthdateController,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return FormDecoration(
      height: Responsive.screenHeight(context) * 0.55,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.screenWidth(context) * 0.05,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomDatePickerField(
                controller: birthdateController,
                hintSize: Responsive.textSize(context, 8),
                lableSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                labeltext: 'تاريخ الميلاد',
                validatorText: 'الرجاء ادخال تاريخ الميلاد',
                validator: (value) =>
                value == null || value.isEmpty ? 'الرجاء ادخال تاريخ الميلاد' : null,

              ),
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: passwordController,

                labelText: 'كلمة المرور',
                validatorText: 'الرجاء ادخال كلمة المرور',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال كلمة المرور';
                  } else if (value.length < 6) {
                    return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: confirmPasswordController,
                labelText: 'تأكيد كلمة المرور',
                validatorText: 'الرجاء ادخال تأكيد كلمة المرور',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال تأكيد كلمة المرور';
                  } else if (value != passwordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  return CustomButton(
                    fontWeight: FontWeight.w600,
                    width: Responsive.screenWidth(context) * 0.9,
                    height: Responsive.screenHeight(context) * 0.06,
                    isLoading: state is AuthenticationLoading,
                    loadingSize: Responsive.screenHeight(context) * 0.04,
                    loadingColor: Colors.white,
                    text: state is AuthenticationLoading ? 'جاري التحميل...' : 'انشاء حساب',
                    color: Constants.mainColor,
                    textSize: Responsive.textSize(context, 16),
                    borderColor: Constants.secondaryColor,
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        // Form is valid and passwords match
                        SubmitSignUpFormFun.trySubmitForm(
                          context,
                          formKey,
                          firstname,
                          lastname,
                          passwordController,
                          phoneController,
                          birthdateController,
                        );
                      }
                    },
                    textColor: Colors.white,
                  );
                },
              ),
              CustomButton(
                fontWeight: FontWeight.w600,
                textSize: Responsive.textSize(context, 16),
                width: Responsive.screenWidth(context) * 0.9,
                height: Responsive.screenHeight(context) * 0.06,
                text: 'تسجيل الدخول',
                color: Constants.secondaryColor,
                borderColor: Constants.secondaryColor,
                onPress: () => Navigator.pushNamed(context, '/login'),
                textColor: Constants.thirdColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
