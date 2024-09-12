import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:sport/controller/Reservation_fetch/reservation_fetch_state.dart';
import 'package:sport/models/reservation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utilits/secure_data.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationLoading());

  Future<void> fetchReservations() async {
    emit(ReservationLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/active-reservations'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      if (kDebugMode) {
        print(decodedResponse);
      }

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data is Map<String, dynamic> && data['results'] is List) {
          final reservations = Reservation.fromJsonList(data['results']);
          if (reservations.isEmpty) {
            emit(ReservationError('لا توجد حجوزات حالية'));
          } else {
            emit(ReservationLoaded(reservations));
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

  Future<void> fetchReservationHistory() async {
    emit(ReservationLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/reservation-history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      if (kDebugMode) {
        print(decodedResponse);
      }

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data is Map<String, dynamic> && data['results'] is List) {
          final reservations = Reservation.fromJsonList(data['results']);
          if (reservations.isEmpty) {
            emit(ReservationError('لا توجد حجوزات سابقة'));
          } else {
            emit(ReservationLoaded(reservations));
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
}