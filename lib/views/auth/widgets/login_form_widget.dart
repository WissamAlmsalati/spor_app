import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/auth/authintication_cubit.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../functions/submit_form_fun.dart';
import 'coustom_button.dart';
import 'coustom_text_field.dart';
import 'form_decoration.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController firstnameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                lableSize: Responsive.textSize(context, 6),
                hintSize: Responsive.textSize(context, 10),
                validatorSize: Responsive.textSize(context, 6),
                controller: firstnameController,
                labeltext: 'رقم الهاتف',
                validatorText: 'ادخل رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) ? 'ادخل رقم الهاتف' : null,
              ),
              CustomTextField(
                lableSize: Responsive.textSize(context, 8),
                hintSize: Responsive.textSize(context, 8),
                validatorSize: Responsive.textSize(context, 6),
                controller: passwordController,
                labeltext: 'كلمة المرور',
                validatorText: 'ادخل كلمة المرور',
                validator: (value) => (value == null || value.isEmpty) ? 'ادخل كلمة المرور' : null,
              ),
              CustomButton(
                fontWeight: FontWeight.w600,
                textSize: Responsive.textSize(context, 16),
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
                    textSize: Responsive.textSize(context, 16),
                    width: Responsive.screenWidth(context) * 0.9,
                    height: Responsive.screenHeight(context) * 0.06,
                    isLoading: state is AuthenticationLoading,
                    loadingSize: Responsive.screenHeight(context) * 0.04,
                    loadingColor: Constants.mainColor,
                    text: state is AuthenticationLoading ? 'جاري التحميل...' : 'تسجيل الدخول',
                    color: Constants.secondaryColor,
                    borderColor: Constants.secondaryColor,
                    onPress: () {
                      if (kDebugMode) {
                        print('Login button pressed');
                      }
                      SubmitFormFun.trySubmitForm(context, formKey, firstnameController, passwordController);
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
