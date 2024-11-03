import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utilits/secure_data.dart';
import '../../views/profile/widget/coustom_dialog.dart';
import '../Reservation_fetch/reservation_fetch_cubit.dart';
import '../profile/fetch_profile_cubit.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'reverse_requestt_dart__state.dart';

class ReverseRequestCubit extends Cubit<ReverseRequestState> {
  final http.Client _client;

  ReverseRequestCubit() : _client = HttpInterceptor(http.Client()), super(ReverseRequestInitial()) {
    _loadReservationState();
  }

    Future<void> sendReverseRequest(
      int stadiumId,
      String selectedDate,
      int selectedSessionId,
      bool isMonthlyReservation,
      int paymentType,
      BuildContext context) async {
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
  
      final response = await _client.post(
        Uri.parse('https://api.sport.com.ly/player/reserve'),
        headers: requestHeaders,
        body: requestBody,
      );
  
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        print('Request sent successfully');
        emit(ReverseRequestSuccess());
        _showDialog(context, 'Success', 'تم الحجز بنجاح', () {
          Navigator.of(context).pop(); // Pop the screen
        });
        context.read<ReservationCubit>().fetchReservations();
        context.read<FetchProfileCubit>().fetchProfileInfo();
      } else if (response.statusCode == 200) {
        print('Request sent successfully with status 200');
      } else if (response.statusCode == 402) {
        emit(NoBalance("لا يوجد رصيد كافي"));
        _showDialog(context, 'فشل في الحجز', 'لا يوجد رصيد كافي', () {});
      } else if (response.statusCode == 409) {
        emit(ReservationConflict("هناك حجز متعارض"));
        _showDialog(context, 'فشل في الحجز', 'هناك حجز متعارض', () {});
      } else if (response.statusCode == 400) {
        emit(ReverseRequestError('حدث خطأ ما'));
        _showDialog(context, 'Error', 'فشل في الحجز', () {});
      } else if (response.statusCode == 404) {
        emit(ReverseRequestError('Request failed: Not Found (404)'));
        _showDialog(context, 'Error', 'فشل في الحجز', () {});
      } else if (response.statusCode == 500) {
        emit(ReverseRequestError('Request failed: Internal Server Error (500)'));
        _showDialog(context, 'Error', 'فشل في الحجز', () {});
      } else {
        emit(ReverseRequestError('Failed to send request: ${response.reasonPhrase}'));
        _showDialog(context, 'Error', 'فشل في الحجز', () {});
      }
    } catch (e) {
      print('An error occurred: $e');
      emit(ReverseRequestError('An error occurred: $e'));
      _showDialog(context, 'Error', 'فشل في الحجز', () {});
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

  // Helper method to show dialog
  void _showDialog(BuildContext context, String title, String content, VoidCallback onDialogClosed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          canceText: 'حسنا',
          onCancel: () async {
            await _saveReservationState(true);
            Navigator.of(context).pop(); // Close the dialog
            onDialogClosed(); // Execute the callback function
          },
        );
      },
    );
  }
}