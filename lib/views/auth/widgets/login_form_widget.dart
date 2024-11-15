import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/auth/screens/forget_password_screen.dart';
import '../../../controller/auth/authintication_cubit.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../functions/submit_form_fun.dart';
import 'coustom_button.dart';
import 'coustom_text_field.dart';
import 'form_decoration.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormDecoration(
      height: Responsive.screenHeight(context) * 0.47,
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
                isPhoneNumber: true,
                labelSize: Responsive.textSize(context, 6),
                hintSize: Responsive.textSize(context, 10),
                validatorSize: Responsive.textSize(context, 6),
                controller: firstnameController,
                labelText: 'رقم الهاتف',
                validatorText: 'ادخل رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) =>
                (value == null || value.isEmpty) ? 'ادخل رقم الهاتف' : null,
              ),
              CustomTextField(
                labelSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: passwordController,
                obscureText: true,
                labelText: 'كلمة المرور',
                validatorText: 'ادخل كلمة المرور',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال كلمة المرور';
                  } else if (value.length < 8) {
                    return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
                  } else if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                    return 'يجب أن تبدأ كلمة المرور بحرف كبير';
                  }
                  return null;
                },
                showForgotPassword: true,
                onForgotPassword: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()));
                },
              ),
              CustomButton(
                fontWeight: FontWeight.w600,
                textSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                width: Responsive.screenWidth(context) * 0.9,
                height: Responsive.screenHeight(context) * 0.06,
                text: 'انشاء حساب',
                color: Constants.mainColor,
                borderColor: Constants.secondaryColor,
                onPress: () => Navigator.pushNamed(context, '/signup'),
                textColor: Constants.secondaryColor,
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  return CustomButton(
                    fontWeight: FontWeight.w600,
                    textSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    width: Responsive.screenWidth(context) * 0.9,
                    height: Responsive.screenHeight(context) * 0.06,
                    isLoading: state is AuthenticationLoading,
                    loadingSize: Responsive.screenHeight(context) * 0.04,
                    loadingColor: Constants.mainColor,
                    text: state is AuthenticationLoading
                        ? 'جاري التحميل...'
                        : 'تسجيل الدخول',
                    color: Constants.secondaryColor,
                    borderColor: Constants.secondaryColor,
                    onPress: () {
                      if (kDebugMode) {
                        print('Login button pressed');
                      }
                      SubmitFormFun.trySubmitForm(context, formKey,
                          firstnameController, passwordController);
                    },
                    textColor: Constants.thirdColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
