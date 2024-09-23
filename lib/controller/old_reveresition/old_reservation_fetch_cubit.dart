import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:sport/models/reservation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utilits/secure_data.dart';
import '../../services/apis.dart';

part 'old_reservation_fetch_state.dart';

class OldReservationFetchCubit extends Cubit<OldReservationFetchState> {
  OldReservationFetchCubit() : super(OldReservationLoading());

  Future<void> fetchOldReservations({int pageKey = 1}) async {
    emit(OldReservationLoading());
    try {
      final token = await SecureStorageData.getToken();
      if (kDebugMode) {
        print('Token: $token');
      }

      final response = await http.get(
        Uri.parse('${Apis.oldReservations}?page=$pageKey'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      final decodedResponse = utf8.decode(response.bodyBytes);
      if (kDebugMode) {
        print(decodedResponse);
      }

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data is Map<String, dynamic> && data['results'] is List) {
          final reservations = Reservation.fromJsonList(data['results']);
          final isLastPage = data['next'] == null;
          if (reservations.isEmpty && pageKey == 1) {
            emit(OldReservationEmpty('ليس لديك حجوزات سابقة'));
          } else {
            emit(OldReservationLoaded(reservations: reservations, isLastPage: isLastPage));
          }
        } else {
          emit(OldReservationError('Invalid data format'));
        }
      } else if (response.statusCode == 401) {
        emit(UnAuthenticated());
      } else {
        emit(OldReservationError('Failed to fetch reservations'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(OldReservationSocketExceptionError());
      } else {
        emit(OldReservationError('An error occurred: $e'));
      }
    }
  }
}