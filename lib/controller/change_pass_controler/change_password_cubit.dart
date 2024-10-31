import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import '../../utilits/secure_data.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final http.Client _client;

  ChangePasswordCubit() : _client = HttpInterceptor(http.Client()), super(ChangePasswordInitial());

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(ChangePasswordLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await _client.patch(
        Uri.parse('https://api.sport.com.ly/auth/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        print('Password changed successfully');
        emit(ChangePasswordSuccess());
      } else {
        print('Failed to change password: ${response.reasonPhrase}');
        emit(ChangePasswordError('Failed to change password: ${response.reasonPhrase}'));
      }
    } catch (e) {
      print('An error occurred: $e');
      emit(ChangePasswordError('An error occurred: $e'));
    }
  }
}