import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utilits/secure_data.dart';
import '../../views/search_screen/widget/stadium_detail_dialog.dart';
import '../Reservation_fetch/reservation_fetch_cubit.dart';
import '../profile/fetch_profile_cubit.dart';

part 'reverse_requestt_dart__state.dart';

class ReverseRequestCubit extends Cubit<ReverseRequestState> {
  ReverseRequestCubit() : super(ReverseRequestInitial()) {
    _loadReservationState();
  }

  Future<void> sendReverseRequest(int stadiumId, String selectedDate, int selectedSessionId, bool isMonthlyReservation, int paymentType, BuildContext context) async {
    emit(ReverseRequestLoading());
    print('Sending reverse request...');
    try {

      final token = await SecureStorageData.getToken();
      final requestBody = jsonEncode({
        "session": {
          "date": selectedDate,
          "session_id": selectedSessionId,
        },
        "stadium_id": stadiumId,
        "payment_type": paymentType,
        "is_monthly_reservation": isMonthlyReservation,
      });

      final requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('https://api.sport.com.ly/player/reserve'),
        headers: requestHeaders,
        body: requestBody,
      );
      print(response.statusCode);
print(response.body);
      if (response.statusCode == 201) {
        print('Failed to send request: ${response.reasonPhrase}');

        print('Request sent successfully');
        await _saveReservationState(true);
        emit(ReverseRequestSuccess());
        StadiumDetailDialog.showReservationStatusDialog(
            context, 'تم الحجز بنجاح', 'تم حجز الملعب بنجاح');
        context.read<ReservationCubit>().fetchReservations();
      context.read<FetchProfileCubit>().fetchProfileInfo();
      } else if (response.statusCode == 400) {
        emit(NoBalance("لا يوجد رصيد كافي"));
      }else if (response.statusCode == 400){
        print('Failed to send request: ${response.reasonPhrase}');
        emit(ReverseRequestError('حدث خطأ ما'));
      } else if (response.statusCode == 404) {
        print('Failed to send request: ${response.reasonPhrase}');

        print('Request failed: Not Found (404)');
        emit(ReverseRequestError('Request failed: Not Found (404)'));
      } else if (response.statusCode == 500) {
        print('Failed to send request: ${response.reasonPhrase}');

        print('Request failed: Internal Server Error (500)');
        emit(ReverseRequestError('Request failed: Internal Server Error (500)'));
      } else {
        print('Failed to send request: ${response.reasonPhrase}');
        emit(ReverseRequestError('Failed to send request: ${response.reasonPhrase}'));
      }
    } catch (e) {

      print('An error occurred: $e');
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