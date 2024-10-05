import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;

part 'update_profile_state.dart';



class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  Future<void> updateProfile(String firstName, String lastName) async {
    final token = await SecureStorageData.getToken();
    final url = Uri.parse('https://api.sport.com.ly/player/update-profile');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    if (response.statusCode == 200) {
      emit(UpdateProfileSuccess());
    } else {
      emit(UpdateProfileError('Failed to update profile'));
    }
  }
}