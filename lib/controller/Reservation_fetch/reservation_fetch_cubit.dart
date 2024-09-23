// reservation_fetch_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sport/models/reservation.dart';
import '../../utilits/secure_data.dart';
import 'reservation_fetch_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationLoading());

  Future<void> fetchReservations({int pageKey = 1}) async {
    emit(ReservationLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/active-reservations?page=$pageKey'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data is Map<String, dynamic> && data['results'] is List) {
          final reservations = Reservation.fromJsonList(data['results']);
          final isLastPage = data['next'] == null;
          if (reservations.isEmpty) {
            emit(ReservationError('لا توجد حجوزات حالية'));
          } else {
            emit(ReservationLoaded(reservations, isLastPage: isLastPage));
          }
        } else {
          emit(ReservationError('Invalid data format'));
        }
      } else if (response.statusCode == 401) {
        emit(ReservationError('انشئ حساب و احجز ملاعبك المفضلة'));
      } else {
        emit(ReservationError('An error occurred: ${response.reasonPhrase}'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(ReservationError('لا يوجد اتصال بالانترنت'));
      } else {
        emit(ReservationError('An error occurred: $e'));
      }
    }
  }

  Future<void> deleteReservation(int reservationId) async {
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.delete(
        Uri.parse('https://api.sport.com.ly/player/reservations/$reservationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        emit(ReservationDeleted(reservationId));
      } else {
        emit(ReservationError('Failed to delete reservation: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(ReservationError('An error occurred: $e'));
    }
  }
}