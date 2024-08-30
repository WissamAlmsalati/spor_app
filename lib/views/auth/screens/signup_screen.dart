import '../../../app/app_packges.dart';
import '../../../utilits/texts.dart';
import '../widgets/coustom_button.dart';
import '../widgets/coustom_text_field.dart';
import '../widgets/form_decoration.dart';
import '../widgets/logo_title_logo.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController firstname = TextEditingController();
    final TextEditingController lastname = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phone = TextEditingController();
    final TextEditingController birthdate = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: Responsive.screenWidth(context) * 0.07,
                right: Responsive.screenWidth(context) * 0.07,
                top: Responsive.screenHeight(context) * 0.10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  TitleLogoTitle(
                    logo: AppPhotot.signLogo,
                    title: AppText.signUptxt,
                    description: AppText.signUpdes,
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.03),
                  FormDecoration(
                    height: Responsive.screenHeight(context) * 0.55,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Responsive.screenWidth(context) * 0.05,
                          right: Responsive.screenWidth(context) * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                        children: [
                          CustomTextField(
                            lableSize: Responsive.textSize(context, 8),
                            hintSize: Responsive.textSize(context, 8),
                            controller: firstname,
                            labeltext: 'الاسم',
                            validatorText: 'Please enter your firstname',
                          ),
                          CustomTextField(
                            controller: phone,
                            labeltext: 'رقم الهاتف',
                            validatorText: 'Please enter your phone number',
                            lableSize: Responsive.textSize(context, 8),
                            hintSize: Responsive.textSize(context, 8),
                          ),
                          CustomTextField(
                            controller: passwordController,
                            labeltext: 'كلمة المرور',
                            validatorText: 'Please enter your password',
                            lableSize: Responsive.textSize(context, 8),
                            hintSize: Responsive.textSize(context, 8),
                          ),
                          CustomButton(
                            width: Responsive.screenWidth(context) * 0.9,
                            height: Responsive.screenHeight(context) * 0.06,
                            text: 'انشاء حساب',
                            color: Constants.mainColor,
                            textSize: Responsive.textSize(context, 10),
                            borderColor: Constants.secondaryColor,
                            onPress: () {},
                            textColor: Constants.secondaryColor,
                          ),
                          CustomButton(
                            width: Responsive.screenWidth(context) * 0.9,
                            height: Responsive.screenHeight(context) * 0.06,
                            textSize: Responsive.textSize(context, 10),
                            text: 'تسجيل الدخول',
                            color: Constants.secondaryColor,
                            borderColor: Constants.secondaryColor,
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()));
                            },
                            textColor: Constants.thirdColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
