import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final http.Client _client;

  ForgetPasswordCubit() : _client = HttpInterceptor(http.Client()), super(ForgetPasswordInitial());

  String? _token; // Private variable to store the token
  String? _otp;   // Private variable to store the OTP
  String? _username; // Private variable to store the username

  Future<void> sendStep1(String username) async {
    emit(ForgetPasswordLoading());
    print('Sending step 1 request...');
    try {
      final response = await _client.post(
        Uri.parse('https://api.sport.com.ly/auth/forgot-password'),
        body: jsonEncode({'step': 1, 'username': username}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _username = username; // Store the username
        emit(ForgetPasswordStep1Success());
        print('Step 1 success');
      } else {
        final responseBody = jsonDecode(response.body);
        emit(ForgetPasswordFailure('Failed to send step 1: ${responseBody['non_field_errors'] ?? 'Unknown error'}'));
        print('Failed to send step 1: ${responseBody['non_field_errors'] ?? 'Unknown error'}');
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
      print('Error in step 1: $e');
    }
  }

  Future<void> sendStep2(String username, String otp) async {
    emit(ForgetPasswordLoading());
    print('Sending step 2 request...');
    try {
      final response = await _client.post(
        Uri.parse('https://api.sport.com.ly/auth/forgot-password'),
        body: jsonEncode({'step': 2, 'username': username, 'otp_password': otp}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['password_change_token'];
        _otp = otp; // Store the OTP
        emit(ForgetPasswordStep2Success(_token!));
        print('Step 2 success, token: $_token');
      } else {
        final responseBody = jsonDecode(response.body);
        emit(ForgetPasswordFailure('Failed to send step 2: ${responseBody['non_field_errors'] ?? 'Unknown error'}'));
        print('Failed to send step 2: ${responseBody['non_field_errors'] ?? 'Unknown error'}');
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
      print('Error in step 2: $e');
    }
  }

  Future<void> sendStep3(String newPassword) async {
    emit(ForgetPasswordLoading());
    print('Sending step 3 request...');
    try {
      final response = await _client.post(
        Uri.parse('https://api.sport.com.ly/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'step': 3,
          'username': _username, // Use the stored username
          'otp_password': _otp, // Use the stored OTP
          'new_password': newPassword,
          'change_password_token': _token,
        }),
      );
      print('Response: ${response.body}');
      print('Request: ${response.request}');
      if (response.statusCode == 200) {
        emit(ForgetPasswordStep3Success());
        print('Step 3 success');
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['non_field_errors'] ?? 'Unknown error';
        emit(ForgetPasswordFailure('Failed to send step 3: $errorMessage'));
        print('Failed to send step 3: $errorMessage');
      }
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
      print('Error in step 3: $e');
    }
  }
}