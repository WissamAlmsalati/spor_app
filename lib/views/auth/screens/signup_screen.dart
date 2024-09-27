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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  // Function to navigate between pages
  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FocusScope(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            children: [
              _buildSignUpForm(context),
              _buildPasswordAndBirthDayForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
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
            FormDecoration(
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
                        labelSize: Responsive.textSize(context, 6),
                        hintSize: Responsive.textSize(context, 10),
                        validatorSize: Responsive.textSize(context, 6),
                        controller: firstnameController,
                        labelText: 'الاسم',
                        validatorText: 'الرجاء ادخال الاسم',
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء ادخال الاسم'
                            : null,
                      ),
                      CustomTextField(
                        labelSize: Responsive.textSize(context, 6),
                        hintSize: Responsive.textSize(context, 10),
                        validatorSize: Responsive.textSize(context, 6),
                        controller: lastnameController,
                        labelText: 'اللقب',
                        validatorText: 'الرجاء ادخال اللقب',
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء ادخال اللقب'
                            : null,
                      ),
                      CustomTextField(
                        labelSize: Responsive.textSize(context, 6),
                        hintSize: Responsive.textSize(context, 10),
                        validatorSize: Responsive.textSize(context, 6),
                        controller: phoneController,
                        labelText: 'رقم الهاتف',
                        validatorText: 'الرجاء ادخال رقم الهاتف',
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء ادخال رقم الهاتف'
                            : null,
                      ),
                      CustomButton(
                        height: Responsive.screenHeight(context) * 0.06,
                        width: Responsive.screenWidth(context) * 0.9,
                        text: 'التالي',
                        color: Constants.mainColor,
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            nextPage();
                          }
                        },
                        textColor: Colors.white,
                      ),
                      CustomButton(
                        height: Responsive.screenHeight(context) * 0.06,
                        width: Responsive.screenWidth(context) * 0.9,
                        text: 'تسجيل الدخول',
                        color: Constants.secondaryColor,
                        onPress: () => Navigator.pushNamed(context, '/login'),
                        textColor: Constants.thirdColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordAndBirthDayForm(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return SingleChildScrollView(
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
            ),
            FormDecoration(
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
                        labeltext: 'تاريخ الميلاد',
                        validatorText: 'الرجاء ادخال تاريخ الميلاد',
                        validator: (value) => value == null || value.isEmpty
                            ? 'الرجاء ادخال تاريخ الميلاد'
                            : null,
                      ),
                      CustomTextField(
                        labelSize: Responsive.textSize(context, 6),
                        hintSize: Responsive.textSize(context, 10),
                        validatorSize: Responsive.textSize(context, 6),
                        controller: passwordController,
                        labelText: 'كلمة المرور',
                        validatorText: 'الرجاء ادخال كلمة المرور',
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
                      ),
                      CustomTextField(
                        labelSize: Responsive.textSize(context, 6),
                        hintSize: Responsive.textSize(context, 10),
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
                            height: Responsive.screenHeight(context) * 0.06,
                            width: Responsive.screenWidth(context) * 0.9,
                            text: state is AuthenticationLoading
                                ? 'جاري التحميل...'
                                : 'انشاء حساب',
                            color: Constants.mainColor,
                            onPress: () {
                              if (formKey.currentState!.validate()) {
                                SubmitSignUpFormFun.trySubmitForm(
                                  context,
                                  formKey,
                                  firstnameController,
                                  lastnameController,
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
                        text: 'رجوع',
                        color: Constants.secondaryColor,
                        onPress: previousPage,
                        textColor: Constants.thirdColor,
                        height: Responsive.screenHeight(context) * 0.06,
                        width: Responsive.screenWidth(context) * 0.9,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}