import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;

import '../../views/profile/widget/coustom_dialog.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  Future<void> updateProfile(String firstName, String lastName, BuildContext context) async {
    final token = await SecureStorageData.getToken();
    final url = Uri.parse('https://api.sport.com.ly/player/change-name');
    print('Updating profile');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      emit(UpdateProfileSuccess());
    } else {
      print('Failed to update profile: ${response.reasonPhrase}');
      emit(UpdateProfileError('Failed to update profile'));
    }
  }
}