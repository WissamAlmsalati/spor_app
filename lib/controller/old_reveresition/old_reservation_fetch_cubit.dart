import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:sport/controller/old_reveresition/old_reservation_fetch_state.dart';
import 'package:sport/models/reservation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utilits/secure_data.dart';
import '../../services/apis.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

class OldReservationFetchCubit extends Cubit<OldReservationFetchState> {
  final http.Client _client;

  OldReservationFetchCubit() : _client = HttpInterceptor(http.Client()), super(OldReservationLoading());

  int _currentPage = 1; // Track the current page number
  List<Reservation> _reservations = []; // Store fetched old reservations
  bool _isLastPage = false; // Track if the last page is reached

  Future<List<Reservation>> fetchOldReservations({int pageKey = 1}) async {
    if (pageKey == 1) {
      emit(OldReservationLoading()); // Emit loading state for the first page
    }

    if (_isLastPage && pageKey != 1) return []; // Return if it's the last page

    try {
      final token = await SecureStorageData.getToken();
      final response = await _client.get(
        Uri.parse('${Apis.oldReservations}?page=$pageKey'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data is Map<String, dynamic> && data['results'] is List) {
          final reservations = Reservation.fromJsonList(data['results']);
          _currentPage = pageKey;

          if (pageKey == 1) {
            _reservations = reservations; // Reset list for the first page
          } else {
            _reservations.addAll(reservations); // Add to existing list for subsequent pages
          }

          _isLastPage = data['next'] == null; // Check if there are more pages
          emit(OldReservationLoaded(_reservations, _isLastPage));
          return reservations;
        } else {
          emit(OldReservationError('Invalid data format'));
        }
      } else if (response.statusCode == 401) {
        emit(UnAuthenticatedUser());
      } else {
        emit(OldReservationError('Error: ${response.reasonPhrase}'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(OldReservationSocketExceptionError());
      } else {
        emit(OldReservationError('An error occurred: $e'));
      }
    }

    return [];
  }

  void loadNextPage() {
    if (!_isLastPage) {
      _currentPage++;
      fetchOldReservations(pageKey: _currentPage);
    }
  }
}