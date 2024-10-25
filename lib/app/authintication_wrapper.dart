import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/auth/authintication_cubit.dart';
import '../utilits/loading_animation.dart';
import '../utilits/responsive.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushReplacementNamed(context, '/homeNavigation');
        } else if (state is AuthenticationUnauthenticated || state is AuthenticationPhoneNotVirefy) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return Center(child: LoadingAnimation(size: Responsive.screenWidth(context) * 0.2));
        } else {
          return Container(
            color: Colors.white,
          );
        }
      },
    );
  }
}