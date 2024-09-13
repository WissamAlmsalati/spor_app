import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repostry/staduim_repostry.dart';
import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;

part 'reverse_requestt_dart__state.dart';

class ReverseRequestCubit extends Cubit<ReverseRequestState> {
  ReverseRequestCubit() : super(ReverseRequestInitial()) {
    _loadReservationState();
  }

  Future<void> sendReverseRequest(int stadiumId, String selectedDate, int selectedSessionId, bool isMonthlyReservation, int paymentType) async {
    emit(ReverseRequestLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.post(
        Uri.parse('https://api.sport.com.ly/player/reserve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "session": {
            "date": selectedDate,
            "session_id": selectedSessionId,
          },
          "stadium_id" : stadiumId,
          "payment_type": paymentType,
          "is_monthly_reservation": isMonthlyReservation,
        }),
      );

      // Log the response status and body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        await _saveReservationState(true);
        emit(ReverseRequestSuccess());
      } else if (response.statusCode == 404) {
        emit(ReverseRequestError('Request failed: Not Found (404)'));
      } else if (response.statusCode == 500) {
        emit(ReverseRequestError('Request failed: Internal Server Error (500)'));
      } else {
        emit(ReverseRequestError('Failed to send request: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(ReverseRequestError('An error occurred: $e'));
    }
  }

  Future<void> _saveReservationState(bool isReserved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isReverseCompleted', isReserved);
  }

  Future<void> _loadReservationState() async {
    final prefs = await SharedPreferences.getInstance();
    final isReserved = prefs.getBool('isReverseCompleted') ?? false;
    if (isReserved) {
      emit(ReverseRequestSuccess());
    }
  }
}