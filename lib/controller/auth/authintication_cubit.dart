import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sport/app/app_packges.dart';
import '../../services/apis.dart';
import '../../views/auth/screens/otp_screen.dart';
import '../Reservation_fetch/reservation_fetch_state.dart';
import '../old_reveresition/old_reservation_fetch_state.dart';

part 'authintication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> sendTokensToServer({
    required String accessToken,
    required String deviceToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.sport.com.ly/notification/register-fcm-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'fcm_token': deviceToken,
        }),
      );

      // Log the response status and body
      print("Sending device token response status: ${response.statusCode}");
      print("Sending device token response body: ${response.body}");
print("notification status code${response.statusCode}");
print("${response.body}");
      // Handle the response codes
      if (response.statusCode == 200) {
        print('Tokens sent successfully.');
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
      } else {
        print('Failed to send tokens: ${response.body}');
      }
    } catch (e) {
      print('Error sending tokens: $e');
    }
  }

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
      print('Sending login request...');
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        await _secureStorage.write(
            key: 'refreshToken', value: responseBody['refresh']);
        await _secureStorage.write(
            key: 'accessToken', value: responseBody['access']);
        await _secureStorage.write(
            key: 'userId', value: responseBody['id'].toString());
        await _secureStorage.write(
            key: 'phoneVerified',
            value: responseBody['phone_verified'].toString());

        await SecureStorageData.setIsSignedUp(true);

        // Call sendTokensToServer after storing the access token and device token
        print('Sending tokens to server...');
        final deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
        if (deviceToken.isNotEmpty) {
          await sendTokensToServer(
            accessToken: responseBody['access'],
            deviceToken: deviceToken,
          );
        } else {
          print('Device token is empty.');
        }

        if (responseBody['phone_verified'] == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(userId: responseBody['id'])),
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
      print('Error: $e');
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        await _secureStorage.write(
            key: 'refreshToken', value: responseBody['refresh']);
        await _secureStorage.write(
            key: 'accessToken', value: responseBody['access']);
        await _secureStorage.write(
            key: 'userId', value: responseBody['id'].toString());
        await _secureStorage.write(
            key: 'phoneVerified',
            value: responseBody['phone_verified'].toString());

        await SecureStorageData.setIsSignedUp(true);

        // Call sendTokensToServer after storing the access token and device token
        print('Sending tokens to server...');
      String? deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
        if (deviceToken.isNotEmpty) {
          print(deviceToken);
          await sendTokensToServer(
            accessToken: responseBody['access'],
            deviceToken: deviceToken,
          );
        } else {
          print('Device token is empty.');
        }

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OtpScreen(userId: responseBody['id'])),
        );
      }else if (response.statusCode == 400) {

        emit(AuthenticationFailure('Phone number already exists'));
      }



      else {
        emit(AuthenticationFailure('Sign up failed'));
      }
    } catch (e) {
      print('Error: $e');
      if (e is SocketException) {
        emit(SocketExceptionError());
      } else {
        emit(AuthenticationFailure(e.toString()));
      }
    }
  }

  // ... (rest of the code remains unchanged)

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
        Navigator.pushNamedAndRemoveUntil(
            context, '/homeNavigation', (route) => false);
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
    context.read<StadiumSearchCubit>().emit(StadiumSearchLoading());
    Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
  }
}
