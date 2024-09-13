import 'package:flutter/foundation.dart';

import '../../../app/app_packges.dart';

class SubmitSignUpFormFun {
  static void trySubmitForm(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController firstname,
      TextEditingController lastNameController,
      TextEditingController passwordController,
      TextEditingController phone,
      TextEditingController birthdate,
      ) {
    final isValid = formKey.currentState?.validate();
    if (kDebugMode) {
      print('Form valid: $isValid');
    }
    if (isValid == true) {
      final username = firstname.text;
      final password = passwordController.text;
      final phoneNumber = phone.text;
      final lastName = lastNameController.text;
      final birthDate = birthdate.text;


      if (kDebugMode) {
        print(
            'Attempting to sign up with username: $username, phone: $phoneNumber, and birthdate: $birthDate');
      }
      context.read<AuthenticationCubit>().signUp(
        password: password,
        phone: phoneNumber,
        context: context,
        firstName: username,
        lastName: lastName,
        birthDay: birthDate,
      );
    } else {
      if (kDebugMode) {
        print('Form is not valid');
      }
    }
  }
}
