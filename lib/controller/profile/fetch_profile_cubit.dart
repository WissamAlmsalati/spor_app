import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../services/apis.dart';
import '../../utilits/secure_data.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'fetch_profile_state.dart';

class FetchProfileCubit extends Cubit<FetchProfileState> {
  final http.Client _client;

  FetchProfileCubit() : _client = HttpInterceptor(http.Client()), super(FetchProfileLoading());

  Future<void> fetchProfileInfo() async {
    emit(FetchProfileLoading());
    try {
      final token = await SecureStorageData.getToken();
      if (kDebugMode) {
        print('Token: $token');
      }

      final response = await _client.get(
        Uri.parse(Apis.fetchProfile),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: $decodedResponse');
      }

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        final userInfo = User.fromJson(data);
        emit(FetchProfileLoaded(userInfo));
      } else if (response.statusCode == 401) {
        emit(FetchProfileEmpty());
      }
    } catch (e) {
      if (e is SocketException) {
        emit(ProfileSocketExceptionError());
      } else {
        emit(FetchProfileError('An error occurred: $e'));
      }
    }
  }

  Future<void> loadSignUpStatus() async {
    try {
      String? isSignedUpString = await SecureStorageData.getIsSign();
      final bool isSignedUp = isSignedUpString == 'true';

      emit(SignUpStatusLoaded(isSignedUp ?? false));
    } catch (e) {
      emit(FetchProfileError('Failed to load sign-up status: $e'));
    }
  }
}