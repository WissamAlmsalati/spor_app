import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../controller/auth/authintication_cubit.dart';

class SubmitFormFun {
  static void trySubmitForm(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController firstname,
      TextEditingController passwordController) {
    final isValid = formKey.currentState?.validate();
    if (kDebugMode) {
      print('Form valid: $isValid');
    }
    if (isValid == true) {
      final username = firstname.text;
      final password = passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        if (kDebugMode) {
          print('Username or password cannot be empty');
        }
        Fluttertoast.showToast(
          msg: 'Username or password cannot be empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      if (kDebugMode) {
        print(
            'Attempting to log in with username: $username and password: $password');
      }
      context.read<AuthenticationCubit>().logIn(
            username: username,
            password: password,
            context: context,
          );
    } else {
      if (kDebugMode) {
        print('Form is not valid');
      }
    }
  }
}
