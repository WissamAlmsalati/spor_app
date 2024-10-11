import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sport/models/reservation.dart';
import '../../utilits/secure_data.dart';
import 'reservation_fetch_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationLoading());

  int _currentPage = 1; // Track the current page number
  List<Reservation> _reservations = []; // Store fetched reservations

  Future<List<Reservation>> fetchReservations({int pageKey = 1}) async {
    if (pageKey == 1) {
      emit(ReservationLoading());
    }

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
          _currentPage = pageKey; // Update current page

          if (pageKey == 1) {
            _reservations = reservations; // Reset list if fetching the first page
          } else {
            _reservations.addAll(reservations); // Append new reservations to the list
          }

          emit(ReservationLoaded(_reservations)); // Emit loaded state
          return reservations; // Return reservations for further processing
        } else {
          emit(ReservationError('Invalid data format'));
        }
      } else if (response.statusCode == 401) {
        emit(ReservationError('Unauthorized'));
      } else {
        emit(ReservationError('An error occurred: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(ReservationError('An error occurred: $e'));
    }

    return []; // Return an empty list on failure
  }
}
