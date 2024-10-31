import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/stedum_model.dart';
import '../../services/apis.dart';

part 'stidum_search_state.dart';

class StadiumSearchCubit extends Cubit<StadiumSearchState> {
  StadiumSearchCubit() : super(StadiumSearchInitial());

  DateTime? selectedDate;
  String searchText = '';
  int? selectedSessionId;
  String? selectedTimeFrom;

  void selectDate(DateTime date) {
    selectedDate = date;
    emit(StadiumSearchDateSelected(date));
  }

  void updateSearchText(String text) {
    searchText = text;
    emit(StadiumSearchTextUpdated(text));
  }

  void selectSessionId(int sessionId) {
    selectedSessionId = sessionId;
    emit(StadiumSearchSessionIdSelected(sessionId));
  }

  void selectTimeFrom(String timeFrom) {
    selectedTimeFrom = timeFrom;
    emit(StadiumSearchTimeFromSelected(timeFrom));
  }

Future<void> searchStadiumsWithFilter({
  required String name,
  required int sessionId,
  required String startDate,
  required String endDate,
  required String timeFrom,
  required String timeTo,
}) async {
  emit(StadiumSearchLoading());
  try {
    print('searchStadiumsWithFilter');

    // Parse the selected date and time
    final selectedDate = DateTime.parse(startDate);
    final timeFromParts = timeFrom.split(':');
    final timeFromDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(timeFromParts[0]),
      int.parse(timeFromParts[1]),
    );

    // Add one hour to get timeTo
    final timeToDateTime = timeFromDateTime.add(const Duration(hours: 1));
    final formattedTimeFrom = timeFromDateTime.toIso8601String().substring(11, 19);
    final formattedTimeTo = timeToDateTime.toIso8601String().substring(11, 19);

    // Construct the query parameters
    final queryParams = {
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'time_from': formattedTimeFrom,
      'time_to': formattedTimeTo,
      'id': '$sessionId',
    };

    // Print the query parameters
    print('Query Parameters: $queryParams');

    // Build the query string
    final queryString = Uri(queryParameters: queryParams).query;

    // Ensure the base URL does not end with a question mark
    final baseUrl = Apis.searchStadiumWithQuery.endsWith('?')
        ? Apis.searchStadiumWithQuery.substring(0, Apis.searchStadiumWithQuery.length - 1)
        : Apis.searchStadiumWithQuery;

    // Print the full request URL
    final requestUrl = '$baseUrl?$queryString';
    print('Request URL: $requestUrl');

    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${utf8.decode(response.bodyBytes)}');
      final data = json.decode(utf8.decode(response.bodyBytes))['results'] as List;
      final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
      emit(StadiumSearchLoaded(stadiums: stadiums));
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      final errorMessage = errorData['detail'] ?? 'Failed to load stadiums';
      emit(StadiumSearchError(message: errorMessage));
    }
  } catch (e) {
    if (e is SocketException) {
      emit(StadiumSearchErrorSocketException());
    } else {
      emit(StadiumSearchError(message: e.toString()));
    }
  }
}
  Future<void> searchStadiums({
    required String name,
    String? city,
    DateTime? date,
    int? sessionId,
  }) async {
    emit(StadiumSearchLoading());
    try {
      final queryParams = {
        'name': name,
        if (city != null) 'city': city,
        if (sessionId != null) 'session_id': sessionId.toString(),
      };

      final queryString = Uri(queryParameters: queryParams).query;
      final baseUrl = Apis.searchStadiumWithQuery.endsWith('?')
          ? Apis.searchStadiumWithQuery.substring(0, Apis.searchStadiumWithQuery.length - 1)
          : Apis.searchStadiumWithQuery;
      final requestUrl = '$baseUrl?$queryString';

      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes))['results'] as List;
        final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
        emit(StadiumSearchLoaded(stadiums: stadiums));
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = errorData['detail'] ?? 'Failed to load stadiums';
        emit(StadiumSearchError(message: errorMessage));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(StadiumSearchErrorSocketException());
      } else {
        emit(StadiumSearchError(message: e.toString()));
      }
    }
  }

  void resetSearch() {
    selectedDate = null;
    searchText = '';
    selectedSessionId = null;
    selectedTimeFrom = null;
    emit(StadiumSearchInitial());
  }
}