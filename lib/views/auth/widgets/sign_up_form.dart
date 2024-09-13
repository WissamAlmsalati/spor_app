import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/app_packges.dart';
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
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController birthdateController = TextEditingController();

    return FormDecoration(
      height: Responsive.screenHeight(context) * 0.75,
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
                lableSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: firstnameController,
                labeltext: 'الاسم',
                validatorText: 'الرجاء ادخال الاسم',
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء ادخال الاسم'
                    : null,
              ),
              CustomTextField(
                lableSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: lastnameController,
                labeltext: 'اللقب',
                validatorText: 'الرجاء ادخال اللقب',
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء ادخال اللقب'
                    : null,
              ),
              CustomTextField(
                lableSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: phoneController,
                labeltext: 'رقم الهاتف',
                validatorText: 'الرجاء ادخال رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء ادخال رقم الهاتف'
                    : null,
              ),
              CustomTextField(
                lableSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: passwordController,
                labeltext: 'كلمة المرور',
                validatorText: 'الرجاء ادخال كلمة المرور',
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء ادخال كلمة المرور'
                    : null,
              ),
              CustomDatePickerField(
                controller: birthdateController,
                hintSize: Responsive.textSize(context, 8),
                lableSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                labeltext: 'تاريخ الميلاد',
                validatorText: 'الرجاء ادخال تاريخ الميلاد',
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء ادخال تاريخ الميلاد'
                    : null,
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
                    text: state is AuthenticationLoading
                        ? 'جاري التحميل...'
                        : 'انشاء حساب',
                    color: Constants.mainColor,
                    textSize: Responsive.textSize(context, 16),
                    borderColor: Constants.secondaryColor,
                    onPress: () {
                      SubmitSignUpFormFun.trySubmitForm(
                        context,
                        formKey,
                        firstnameController,
                        lastnameController,
                        passwordController,
                        phoneController,
                        birthdateController,
                      );
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