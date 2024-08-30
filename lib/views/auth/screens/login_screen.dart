import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../../app/app_packges.dart';
import '../../../utilits/texts.dart';
import '../widgets/login_form_widget.dart';
import '../widgets/logo_title_logo.dart';


class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusBarTheme = CustomThemeData.getStatusBarTheme(context, isDarkMode);

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushNamed(context, '/homeNavigation');
        } else if (state is SocketExceptionError) {
          showToast(
            "لا يوجد اتصال بالانترنت",
            context: context,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(
                Responsive.screenHeight(context) * 0.02),
            textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
            alignment: Alignment.center,
            animation: StyledToastAnimation.fade,
            reverseAnimation: StyledToastAnimation.fade,
          );
        } else if (state is AuthenticationFailure) {
          showToast(
            "ليس لديك حساب ,قم بانشاء حساب جديد",
            context: context,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(
                Responsive.screenHeight(context) * 0.02),
            textStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
            alignment: Alignment.center,
            animation: StyledToastAnimation.fade,
            reverseAnimation: StyledToastAnimation.fade,
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarTheme,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: Responsive.screenWidth(context) * 0.07,
                    right: Responsive.screenWidth(context) * 0.07,
                    top: Responsive.screenHeight(context) * 0.10),
                child: Column(
                  children: [
                    const TitleLogoTitle(
                      logo: AppPhotot.signLogo,
                      title: AppText.signInTxt,
                      description: AppText.signInDes,
                    ),
                    SizedBox(height: Responsive.screenHeight(context) * 0.05),
                    const LoginFormWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}