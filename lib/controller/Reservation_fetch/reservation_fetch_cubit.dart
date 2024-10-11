import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sport/app/app_packges.dart';
import 'dart:convert';
import 'package:sport/models/reservation.dart';
import '../../utilits/secure_data.dart';
import 'reservation_fetch_state.dart'; // Ensure this import is correct

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationLoading());

  int _currentPage = 0;
  bool _isLastPage = false;
  List<Reservation> _reservations = [];

  Future<void> fetchReservations({int pageKey = 0}) async {
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
          _isLastPage = data['next'] == null;
          if (pageKey == 0) {
            _reservations = reservations;
          } else {
            _reservations.addAll(reservations);
          }
          emit(ReservationLoaded(_reservations, isLastPage: _isLastPage));
        } else {
          emit(ReservationError('Invalid data format'));
        }
      } else if (response.statusCode == 401) {
        emit(UnAuthenticatedUser());
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

  void loadNextPage() {
    if (!_isLastPage) {
      _currentPage++;
      fetchReservations(pageKey: _currentPage);
    }
  }
}