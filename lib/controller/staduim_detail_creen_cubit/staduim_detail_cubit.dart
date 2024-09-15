import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  int selectedSessionId = -1;
  String selectedTime = '';

  Future<void> fetchStadiumById(int stadiumId) async {
    emit(StaduimDetailLoading());
    try {
      final token = await SecureStorageData.getToken();

      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/stadium-info?stadium_id=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',


          'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final stadiumInfo = StadiumInfo.fromJson(data['stadium_info']);
        final availableSessions = (data['available_sessions'] as List)
            .map((session) => AvailableSession.fromJson(session))
            .toList();

        if (availableSessions.isEmpty) {
          emit(StaduimDetailLoadedEmptySession(stadiumInfo: stadiumInfo));
        } else {
          selectedDate = availableSessions.first.date;
          selectedSessionId = availableSessions.first.sessions.first.sessionId;
          selectedTime = availableSessions.first.sessions.first.startTime;
          emit(StaduimDetailLoaded(stadiumInfo: stadiumInfo, availableSessions: availableSessions));
        }
      } else {
        emit(StaduimDetailError(message: 'Failed to load stadium details'));
      }
    } catch (e) {
      emit(StaduimDetailError(message: e.toString()));
    }
  }

  Future<void> fetchStadiumInfo(int stadiumId) async {
    await fetchStadiumById(stadiumId);
  }

  void setSelectedDate(String date) {
    selectedDate = date;
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
      ));
    }
  }

  void setSelectedSessionId(int sessionId) {
    selectedSessionId = sessionId;
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
      ));
    }
  }

  void setSelectedTime(String time) {
    selectedTime = time;
    if (state is StaduimDetailLoaded) {
      emit(StaduimDetailLoaded(
        stadiumInfo: (state as StaduimDetailLoaded).stadiumInfo,
        availableSessions: (state as StaduimDetailLoaded).availableSessions,
      ));
    }
  }
}