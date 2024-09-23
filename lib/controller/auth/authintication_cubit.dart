import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/app/app_packges.dart';
import '../../services/apis.dart';
import '../../app/app_cubits.dart';
import '../../utilits/secure_data.dart';
import '../../views/auth/screens/otp_screen.dart';
import '../Reservation_fetch/reservation_fetch_cubit.dart';
import '../Reservation_fetch/reservation_fetch_state.dart';
import '../fetch_favorite/fetch_favorite_cubit.dart';
import '../old_reveresition/old_reservation_fetch_cubit.dart';
import '../profile/fetch_profile_cubit.dart';

part 'authintication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> logIn({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      emit(AuthenticationFailure('Username or password cannot be empty'));
      return;
    }
    try {
      emit(AuthenticationLoading());
      final response = await http.post(
        Uri.parse(Apis.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        await _secureStorage.write(key: 'refreshToken', value: responseBody['refresh']);
        await _secureStorage.write(key: 'accessToken', value: responseBody['access']);
        await _secureStorage.write(key: 'userId', value: responseBody['id'].toString());
        await _secureStorage.write(key: 'phoneVerified', value: responseBody['phone_verified'].toString());

        await SecureStorageData.setIsSignedUp(true);

        if (responseBody['phone_verified'] == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(userId: responseBody['id'])),
            (route) => false,
          );
          emit(AuthenticationPhoneNotVirefy());
        } else {
          emit(AuthenticationAuthenticated());
          RefreshCubit.refreshCubits(context);
          Navigator.pushNamed(context, '/homeNavigation');
        }
      } else {
        emit(AuthenticationFailure('Invalid username or password'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(SocketExceptionError());
      } else {
        emit(AuthenticationFailure(e.toString()));
      }
    }
  }

  Future<void> signUp({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDay,
    required BuildContext context,
    int userType = 2,
  }) async {
    if (phone.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        birthDay.isEmpty) {
      emit(AuthenticationFailure('All fields are required'));
      return;
    }

    try {
      emit(AuthenticationLoading());

      final response = await http.post(
        Uri.parse(Apis.signUp),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'phone': phone,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'birth_day': birthDay,
          'user_type': userType.toString(),
        },
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        await _secureStorage.write(key: 'refreshToken', value: responseBody['refresh']);
        await _secureStorage.write(key: 'accessToken', value: responseBody['access']);
        await _secureStorage.write(key: 'userId', value: responseBody['id'].toString());
        await _secureStorage.write(key: 'phoneVerified', value: responseBody['phone_verified'].toString());

        await SecureStorageData.setIsSignedUp(true);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OtpScreen(userId: responseBody['id'])),
           
        );
      } else {
        emit(AuthenticationFailure('Sign up failed'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(SocketExceptionError());
      } else {
        emit(AuthenticationFailure(e.toString()));
      }
    }
  }

  Future<void> sendOtp(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(Apis.phoneVerify),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'step': '1',
          'user_id': userId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully.');
      } else {
        emit(AuthenticationFailure('Failed to send OTP'));
        print('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
      print('Error sending OTP: $e');
    }
  }

  Future<void> verifyOtp(BuildContext context, int userId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(Apis.phoneVerify),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'step': '2',
          'user_id': userId.toString(),
          'otp_password': otp,
        }),
      );
      if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();
        await storage.write(key: 'phoneVerified', value: 'true');
        emit(AuthenticationAuthenticated());
        Navigator.pushNamedAndRemoveUntil(context, '/homeNavigation', (route) => false);
      } else {
        emit(AuthenticationFailure('Invalid OTP'));
      }
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }

  Future<void> checkAuthentication() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    String? phoneVerified = await _secureStorage.read(key: 'phoneVerified');
    if (token != null && token.isNotEmpty) {
      if (phoneVerified == 'false') {
        emit(AuthenticationPhoneNotVirefy());
      } else {
        emit(AuthenticationAuthenticated());
      }
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  void logOut(BuildContext context) async {
    await SecureStorageData.clearData();
    emit(AuthenticationUnauthenticated());

    context.read<AuthenticationCubit>().emit(AuthenticationUnauthenticated());
    context.read<FetchProfileCubit>().emit(FetchProfileLoading());
    context.read<ReservationCubit>().emit(ReservationLoading());
    context.read<OldReservationFetchCubit>().emit(OldReservationLoading());
    context.read<FetchFavoriteCubit>().emit(FetchFavoriteLoading());

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/onboarding',
      (route) => false,
    );
  }
}