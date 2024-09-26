import '../views/auth/screens/otp_screen.dart';
import 'app_packges.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: SplashScreen(), // Start with SplashScreen
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 400),
        );

      case '/signup':
        return PageTransition(
          child: const SignUp(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );

      case '/login':
        return PageTransition(
          child: const SignIn(),
          type: PageTransitionType.leftToRight,
          duration: const Duration(milliseconds: 300),
        );

      case '/visitor':
        return PageTransition(
          child: HomeNavigation(),
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 300),
        );

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      case '/changePasswordScreen':
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

      case '/homeNavigation':
        return PageTransition(
          child: HomeNavigation(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
        );

      case '/accountDetails':
        return MaterialPageRoute(builder: (_) => const AccountDetails());

      case '/searchScreen':
        return MaterialPageRoute(builder: (_) => StadiumSearchScreen());

      case '/walletScreen':
        return MaterialPageRoute(builder: (_) => const WalletScreen());

      case '/createOrLoginScreen':
        return MaterialPageRoute(builder: (_) => const CreateOrLoginScreen());

      case '/otpScreen':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(userId: args['userId']),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR: Route not found'),
        ),
      );
    });
  }
}
