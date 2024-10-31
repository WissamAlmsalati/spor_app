import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/avilable_sesion_model.dart';
import '../../models/staduim_info.dart';
import '../../repostry/staduim_repostry.dart';
import '../../utilits/secure_data.dart';

part 'staduim_detail_state.dart';

class StadiumDetailCubit extends Cubit<StaduimDetailState> {
  final StadiumRepository stadiumRepository;

  StadiumDetailCubit(this.stadiumRepository) : super(StaduimDetailInitial());

  String selectedDate = '';
  int? selectedSessionId;
  String selectedTime = '';

  Future<void> fetchStadiumById(int stadiumId) async {
    emit(StaduimDetailLoading());
    try {
      final token = await SecureStorageData.getToken();

      final url = 'https://api.sport.com.ly/player/stadium-info?stadium_id=$stadiumId';
      if (kDebugMode) {
        print('Fetching stadium details from: $url');
      }

      final headers = <String, String>{};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
      }

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        final data = json.decode(utf8.decode(response.bodyBytes));
        final stadiumInfo = StadiumInfo.fromJson(data['stadium_info']);
        final availableSessions = (data['available_sessions'] as List)
            .map((session) => AvailableSession.fromJson(session))
            .toList();

        if (availableSessions.isEmpty) {
          emit(StaduimDetailLoadedEmptySession(
              stadiumInfo: stadiumInfo, isFavorite: stadiumInfo.isFavourite));
        } else {
          selectedDate = availableSessions.first.date;
          selectedSessionId = null; // No session selected initially
          selectedTime = '';
          emit(StaduimDetailLoaded(
              stadiumInfo: stadiumInfo,
              availableSessions: availableSessions,
              isFavorite: stadiumInfo.isFavourite));
        }
      } else {
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }

        emit(StaduimDetailError(message: 'Failed to load stadium details'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      emit(StaduimDetailError(message: e.toString()));
    }
  }

  Future<void> fetchStadiumInfo(int stadiumId) async {
    await fetchStadiumById(stadiumId);
  }

  void setSelectedDate(String date) {
    selectedDate = date;
    selectedSessionId = null; // Reset session selection when date changes
    selectedTime = '';
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
        isFavorite: (state as StaduimDetailLoaded).isFavorite,
      ));
    }
  }

  void setSelectedSessionId(int? sessionId, String time) {
    selectedSessionId = sessionId;
    selectedTime = time;
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
        isFavorite: (state as StaduimDetailLoaded).isFavorite,
      ));
    }
  }

  void setSelectedTime(String time) {
    selectedTime = time;
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
        isFavorite: (state as StaduimDetailLoaded).isFavorite,
      ));
    }
  }

  void toggleFavoriteStatus() {
    if (state is StaduimDetailLoaded) {
      final currentState = state as StaduimDetailLoaded;
      emit(StaduimDetailLoaded(
        stadiumInfo: currentState.stadiumInfo,
        availableSessions: currentState.availableSessions,
        isFavorite: !currentState.isFavorite,
      ));
    } else if (state is StaduimDetailLoadedEmptySession) {
      final currentState = state as StaduimDetailLoadedEmptySession;
      emit(StaduimDetailLoadedEmptySession(
        stadiumInfo: currentState.stadiumInfo,
        isFavorite: !currentState.isFavorite,
      ));
    }
  }
}